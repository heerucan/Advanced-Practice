//
//  CounterViewReactor.swift
//  ArchitecturePractice
//
//  Created by heerucan on 2023/03/18.
//

import Foundation

import ReactorKit
import RxSwift

final class CounterViewReactor: Reactor {
    
    enum Action { // 사용자 액션(입력)
        case increase
        case decrease
    }
    
    enum Mutation { // 상태변경
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    struct State { // 현재 뷰의 상태
        var value: Int
        var isLoading: Bool
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(value: 0, isLoading: false)
    }
    
    // action이 들어오면 어떤 작업 처리를 해줄건지
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([ // 여러개의 옵저버블을 하나로 합쳐서 순서대로 방출
                Observable.just(.setLoading(true)),
                Observable.just(.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        }
    }
    
    // State(이전 상태)와 Mutate(처리단위)에서 어떤 새로운 State(최종적으로 뷰에게 보낼 상태)를 반환할 건지
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
