//
//  AuthAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import Alamofire

protocol AuthAPIType: AnyObject {
    func signup(_ convertible: AuthRouter)
}

final class AuthAPIManager: BaseAPIManager, AuthAPIType {
    static let shared = AuthAPIManager()
    private override init() { }
    
    // MARK: - POST 회원가입
    
    func signup(_ convertible: AuthRouter) {
        AF.request(convertible)
            .responseString { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    let result = self.judgeStatus(statusCode: statusCode, data: data)
                    print("회원가입 성공", result)
                    
                case .failure(let error):
                    print("회원가입 실패", error.localizedDescription)
                }
            }
    }
}
