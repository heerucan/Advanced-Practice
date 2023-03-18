//
//  MemoViewModel.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/13.
//

import Foundation

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

final class MemoViewModel: ViewModelType {
    
    struct Input { }
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
