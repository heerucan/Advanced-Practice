//
//  PhotoAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import Foundation

import Alamofire

protocol PhotoAPIType: AnyObject {
    typealias Completion<T> = ((Result<T, APIError>) -> Void)
    func fetchData<T: Decodable>(_ convertible: PhotoRouter, completion: @escaping Completion<T>)
}

final class PhotoAPIManager: BaseAPIManager, PhotoAPIType {
    static let shared = PhotoAPIManager()
    private override init() { }
    
    typealias Completion<T> = ((Result<T, APIError>) -> Void)
        
    func fetchData<T: Decodable>(_ convertible: PhotoRouter, completion: @escaping Completion<T>) {
        AF.request(convertible)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                switch response.result {
                case .success(let data):
                    let result = self.judgeStatus(statusCode: statusCode, data: data)
                    completion(result)
                    
                case .failure: completion(.failure(.badRequest))
                }
            }
    }
}
