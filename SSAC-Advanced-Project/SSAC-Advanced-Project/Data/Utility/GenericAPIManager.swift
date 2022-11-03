//
//  GenericAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/03.
//

import Foundation

import Alamofire

final class GenericAPIManager {
    static let shared = GenericAPIManager()
    private init() { }
            
    typealias Completion<T> = ((Result<T, APIError>) -> Void)
    
    func requestData<T: Decodable>(_ type: T.Type = T.self,
                                 _ convertible: URLRequestConvertible,
                                 completion: @escaping Completion<T>) {
        AF.request(convertible)
            .responseDecodable(of: T.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
    }
}
