//
//  PhotoRouter.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

import Alamofire

@frozen
enum PhotoRouter: URLRequestConvertible {
    case searchUser(query: String, page: Int)
    case userProfile(username: String)
    case userPhotos(username: String)
    
    // MARK: - BaseURL
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    // MARK: - Method
    
    private var method: HTTPMethod {
        switch self {
        case .searchUser, .userProfile, .userPhotos: return .get
        }
    }
    
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .searchUser(let query, let page):
            return "/search/users?query=\(query)&per_page=\(page)"
        case .userProfile(let username):
            return "/users/\(username)"
        case .userPhotos(let username):
            return "/users/\(username)/photos"
        }
    }
    
    // MARK: - asURLRequest
    
    func asURLRequest() throws -> URLRequest {
        let urlString = baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: ""))
        var request = URLRequest(url: url!)
        request.method = method
        request.setValue(APIKey.authorization, forHTTPHeaderField: "Authorization")
        return request
    }
}
