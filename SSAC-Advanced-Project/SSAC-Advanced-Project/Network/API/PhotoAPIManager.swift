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
    
    typealias completion<T> = ((T?, Int?, Error?) -> Void)
  
    // MARK: - GET : searchUser
    
    func getSearchUser(query: String, completion: @escaping completion<SearchUser>) {
        AF.request(PhotoRouter.getSearchUser(query: query))
            .validate(statusCode: 200..<500).responseDecodable(of: SearchUser.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)
                print(value)

            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // MARK: - GET : user 여기만 잘들어오고
    
    func getUser(username: String, completion: @escaping completion<User>) {
        AF.request(PhotoRouter.getUserProfile(username: username))
            .responseDecodable(of: User.self) { response in
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
    
    func getUserPhoto(username: String, completion: @escaping completion<UserPhoto>) {
        AF.request(PhotoRouter.getUserPhotos(username: username))
            .responseDecodable(of: UserPhoto.self) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completion(value, statusCode, nil)
                print(value)

            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
}
