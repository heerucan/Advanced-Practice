//
//  GithubReactor.swift
//  ArchitecturePractice
//
//  Created by heerucan on 2023/03/22.
//

import Foundation

import ReactorKit
import RxCocoa

/*
 View -> Reactor(Action -> Mutation -> State) -> View
 */

final class GithubReactor: Reactor {
    
    enum Action { // 사용자의 액션으로 인해 검색어가 호출
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([String], nextPage: Int?)
        case appendRepos([String], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State { // 결국 View는 State를 받아서 보여주니까
        var query: String?
        var nextPage: Int?
        var repos: [String]
        var isLoadingNextPage: Bool
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(repos: [], isLoadingNextPage: false)
    }
    
    // MARK: - Action -> Mutation
    /// 사용자의 액션을 받아서
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return Observable.concat([
                // 1. 현재 검색어로 상태 맞춤
                Observable.just(.setQuery(query)), // action을 받아서 mutation에게 넘겨줘서 Observable<Mutation>으로 변경
                
                // 2. API 호출해서 Repo Setup
                self.search(query: query, page: 1)
                /**
                 단, 새로운 호출 액션이 들어오면 이전 reqeust는 취소시킴
                 take(until:) -> trigger observable이 이벤트를 방출하기 전까지 원본 옵저버블 이벤트 전달
                 즉, self.action.filter(Action.isUpdateQueryAction) 옵저버블이 동작 시
                 self.search~ 옵저버블은 중단되는 것임
                 */
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { .setRepos($0, nextPage: $1)}
            ])
        case .loadNextPage:
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            
            return Observable.concat([
                // 1. 로딩상태 true
                Observable.just(.setLoadingNextPage(true)),
                
                // 2. API 호출해서 Repo Append
                self.search(query: self.currentState.query, page: page)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { .appendRepos($0, nextPage: $1)},
                
                // 3. 로딩상태 false
                Observable.just(.setLoadingNextPage(false))
            ])
        }
    }
    
    // MARK: - Mutation -> State
    /// Mutation을 받아서 State를 업데이트!
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setQuery(let query):
            var newState = state
            newState.query = query
            return newState
            
        case .setRepos(let repos, let nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
            
        case .appendRepos(let repos, let nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
            
        case .setLoadingNextPage(let isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
        
    }
}

// MARK: - Action Extension

extension GithubReactor.Action {
    static func isUpdateQueryAction(_ action: GithubReactor.Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Business Login

extension GithubReactor {
    /// query, page를 기반으로 url을 가져오는 메소드
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return  URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    /// 1. 위 url 메소드를 기반으로 서버통신 후 받아온 응답값을 가져와
    /// 2. repos, nextPage를 반환
    private func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        let emptyResult: ([String], Int?) = (["검색 결과가 없어요"], 0)
        guard let url = url(for: query, page: page) else { return .just(emptyResult) }
        return URLSession.shared.rx.json(url: url)
            .map { json -> ([String], Int?) in
                guard let dict = json as? [String: Any] else { return emptyResult }
                guard let items = dict["items"] as? [[String: Any]] else { return emptyResult }
                
                let repos = items.compactMap { $0["full_name"] as? String }
                let nextPage = repos.isEmpty ? nil : page+1
                return (repos, nextPage)
            }
            .do { error in
                if case .some(.httpRequestFailed(let response, _)) = error as? RxCocoaURLError,
                   response.statusCode == 403 {
                    print("Github API 한계 초과, 60초 기다려")
                }
            }
            .catchAndReturn(emptyResult)
    }
}

