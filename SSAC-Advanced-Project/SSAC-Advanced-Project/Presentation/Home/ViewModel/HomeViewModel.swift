//
//  HomeViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    struct Input {
        var logoutTap: ControlEvent<Void>
    }
    
    struct Output {
        var logoutTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(logoutTap: input.logoutTap)
    }
}
