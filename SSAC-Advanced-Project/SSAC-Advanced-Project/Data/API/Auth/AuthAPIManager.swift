//
//  AuthAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import Alamofire

protocol AuthAPIType: AnyObject {
    func postSignup(_ convertible: AuthRouter)
    func postLogin(_ convertible: AuthRouter)
    func login(_ convertible: AuthRouter)
}

final class AuthAPIManager: BaseAPIManager {
    static let shared = AuthAPIManager()
    private override init() { }
    
    // MARK: - POST 회원가입
    
    func postSignup(_ convertible: AuthRouter) {
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
    
    // MARK: - POST 로그인
    
    func postLogin(_ convertible: AuthRouter) {
        AF.request(convertible)
            .responseDecodable(of: Login.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    let result = self.judgeStatus(statusCode: statusCode, data: data)
                    print("로그인 성공", result.map { $0.token })
                    UserDefaults.standard.set(data.token, forKey: Matrix.token)
                    
                case .failure(let error):
                    print("로그인 실패", error.localizedDescription)
                }
            }
    }
        
    // MARK: - GET 내 프로필 보기
    
    func login(_ convertible: AuthRouter) {
        AF.request(convertible)
            .responseDecodable(of: Profile.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    let result = self.judgeStatus(statusCode: statusCode, data: data)
                    print("내 프로필 성공", result)
                    
                case .failure(let error):
                    print("내 프로필 실패", error.localizedDescription)
                }
            }
    }
}
