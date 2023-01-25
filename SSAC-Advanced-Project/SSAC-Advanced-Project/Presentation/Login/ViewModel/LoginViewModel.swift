//
//  LoginViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    let email = BehaviorRelay(value: "이메일을 입력해주세요")
    let password = BehaviorRelay(value: "비밀번호는 8자 이상입니다")
    let token = PublishSubject<String>()
    
    struct Input {
        var loginTap: ControlEvent<Void>
    }
    
    struct Output {
        var loginTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {        
        return Output(loginTap: input.loginTap)
    }
    
    func login(email: String, password: String) {
        GenericAPIManager.shared.requestData(Login.self, AuthRouter.login(email, password)) { [weak self] response in
            guard let self = self else {
                return
            }
            switch response {
            case .success(let value):
                self.token.onNext(value.token)
                UserDefaults.standard.set(value.token, forKey: Matrix.token)
                
            case .failure(let failure):
                self.token.onError(failure)
            }
        }
    }
}
