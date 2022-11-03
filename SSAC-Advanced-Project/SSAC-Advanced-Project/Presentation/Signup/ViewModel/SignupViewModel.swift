//
//  SignupViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import RxSwift
import RxCocoa

final class SignupViewModel: ViewModelType {
    
    let userName = BehaviorRelay(value: "이름을 입력해주세요")
    let email = BehaviorRelay(value: "이메일을 입력해주세요")
    let password = BehaviorRelay(value: "비밀번호는 8자 이상입니다")
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func signup(userName: String, email: String, password: String) {
//        GenericAPIManager.shared.fetchData(<#T##type: Decodable.Protocol##Decodable.Protocol#>, <#T##convertible: URLRequestConvertible##URLRequestConvertible#>, completion: <#T##((Result<Decodable, APIError>) -> Void)##((Result<Decodable, APIError>) -> Void)##(Result<Decodable, APIError>) -> Void#>)
    }
}
