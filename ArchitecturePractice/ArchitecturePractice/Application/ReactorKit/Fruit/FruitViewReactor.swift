//
//  FruitViewReactor.swift
//  ArchitecturePractice
//
//  Created by heerucan on 2023/03/19.
//

import Foundation

import ReactorKit
import RxSwift

final class FruitViewReactor: Reactor {
    
    // MARK: - Action
    
    enum Action { // 사용자 입력
        case apple
        case banana
        case pineapple
    }
    
    // MARK: - Mutation
    
    enum Mutation { // 상태 변경
        case changeApple
        case changeBanana
        case changePineapple
        case setLoading(Bool)
    }
    
    // MARK: - State
    
    struct State { // 현재 상태
        var fruitName: String
        var isLoading: Bool
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(fruitName: "", isLoading: false)
    }
    
    // MARK: - Action -> Mutation
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .apple:
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                .just(.changeApple).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                .just(Mutation.setLoading(false))
            ])
        case .banana:
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                .just(.changeBanana).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                .just(Mutation.setLoading(false))
            ])
        case .pineapple:
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                .just(.changePineapple).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                .just(Mutation.setLoading(false))
            ])
        }
    }
    
    // MARK: - Mutatoin -> State
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .changeApple:
            newState.fruitName = "사과"
        case .changeBanana:
            newState.fruitName = "바나나"
        case .changePineapple:
            newState.fruitName = "파인애플"
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
