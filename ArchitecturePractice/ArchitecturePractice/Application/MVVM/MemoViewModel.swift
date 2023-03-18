//
//  MemoViewModel.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/13.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
