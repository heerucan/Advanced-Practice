//
//  HomeViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import RxSwift

final class HomeViewModel: ViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
