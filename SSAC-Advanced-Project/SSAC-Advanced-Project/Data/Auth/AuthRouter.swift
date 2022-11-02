//
//  AuthRouter.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

import Alamofire

@frozen
enum AuthRouter: URLRequestConvertible {
    case signup(_ userName: String, _ email: String, _ password: String)
    case login(_ email: String, _ password: String)
    case profile
    
    // MARK: - BaseURL
    
    private var baseURL: URL {
        return URL(string: APIKey.authURL)!
    }
    
    // MARK: - Method
    
    private var method: HTTPMethod {
        switch self {
        case .signup, .login: return .post
        case .profile: return .get
        }
    }
    
    // MARK: - Header
    
    private var headers: HTTPHeaders {
        switch self {
        case .signup, .login:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .profile:
            return ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: Matrix.token)!)"]
        }
    }
    
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .signup:
            return "/signup"
        case .login:
            return "/login"
        case .profile:
            return "/me"
        }
    }
    
    // MARK: - asURLRequest
    
    func asURLRequest() throws -> URLRequest {
        let urlString = baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: ""))
        var request = URLRequest(url: url!)
        request.method = method
        request.headers = headers
        return request
    }
}
