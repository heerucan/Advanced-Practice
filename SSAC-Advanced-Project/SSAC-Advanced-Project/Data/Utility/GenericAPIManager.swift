//
//  GenericAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/03.
//

import Foundation

import Alamofire

final class GenericAPIManager: BaseAPIManager {
    static let shared = GenericAPIManager()
    private override init() { }
            
    func fetchData<T: Decodable>(_ convertible: URLRequestConvertible, completion: @escaping Completion<T>) {
        AF.request(convertible)
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
