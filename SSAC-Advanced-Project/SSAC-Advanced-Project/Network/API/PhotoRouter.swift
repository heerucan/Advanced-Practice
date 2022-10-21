//
//  APIRouter.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

import Alamofire

@frozen enum APIRouter: URLRequestConvertible {
    case getSearchUser(query: String) // 유저 검색하기
    case getUserProfile(username: String) // 유저 정보 가져오기
    case getUserPhotos(username: String) // 유저 이미지 가져오기
    
    // MARK: - BaseURL
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    // MARK: - Method
    
    var method: HTTPMethod {
        switch self {
        case .getSearchUser, .getUserProfile, .getUserPhotos: return .get
        }
    }
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .getSearchUser:
            return "/search/users"
        case .getUserProfile(let username):
            return "/users/\(username)"
        case .getUserPhotos(let username):
            return "/users/\(username)/photos"
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path) // baseURL에 path 부분을 추가하는 코드
        var request = URLRequest(url: url) // URLReqeust에 url을 넣어주고 request에 할당
        request.method = method // request의 method도 할당
        return request
    }
}
