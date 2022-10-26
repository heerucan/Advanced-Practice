//
//  PhotoRouter.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

import Alamofire

@frozen enum PhotoRouter: URLRequestConvertible {
    case getSearchUser(query: String, page: Int) // 유저 검색하기
    case getUserProfile(username: String) // 유저 정보 가져오기
    case getUserPhotos(username: String) // 유저 이미지 가져오기
    
    // MARK: - BaseURL
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    // MARK: - Method
    
    private var method: HTTPMethod {
        switch self {
        case .getSearchUser, .getUserProfile, .getUserPhotos: return .get
        }
    }
    
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .getSearchUser(let query, let page):
            return "/search/users?query=\(query)&per_page=\(page)"
        case .getUserProfile(let username):
            return "/users/\(username)"
        case .getUserPhotos(let username):
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
