//
//  MyObservable.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/14.
//

import Foundation

class MyObservable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
