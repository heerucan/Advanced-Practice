//
//  PhotoAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import Foundation

import Alamofire

final class PhotoAPIManager {
    static let shared = PhotoAPIManager()
    private init() { }
    
    typealias Completion<T> = ((T?, Int?, Error?) -> Void)
  
    // MARK: - GET : searchUser
    
    func getSearchUser(query: String, page: Int, completion: @escaping Completion<SearchUser>) {
        AF.request(PhotoRouter.getSearchUser(query: query, page: page))
            .validate(statusCode: 200..<500).responseDecodable(of: SearchUser.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)

            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // MARK: - GET : user
    
    func getUser(username: String, completion: @escaping Completion<User>) {
        AF.request(PhotoRouter.getUserProfile(username: username))
            .validate(statusCode: 200..<500).responseDecodable(of: User.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)

            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // MARK: - GET : userPhoto
    
    func getUserPhoto(username: String, completion: @escaping Completion<[Photo]>) {
        AF.request(PhotoRouter.getUserPhotos(username: username))
            .validate(statusCode: 200..<500).responseDecodable(of: [Photo].self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)
                print(value)

            case .failure(let error):
                completion(nil, statusCode, error)
                print(error)
            }
        }
    }
}
