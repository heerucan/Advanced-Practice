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
    
    typealias Completion<T> = ((Result<T, APIServiceError>) -> Void)
    
    // MARK: - Fetch Generic Data
    
    func fetchGenericData<T: Decodable>(_ convertible: PhotoRouter, completion: @escaping Completion<T>) {
        AF.request(convertible)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    let result = self.judgeStatus(statusCode: statusCode, data: data)
                    completion(result)
                case .failure: completion(.failure(.badRequest))
                }
            }
    }
    
    // MARK: - Judge Status
    
    private func judgeStatus<T>(statusCode: Int, data: T) -> Result<T, APIServiceError> {
        switch statusCode {
        case 200: return .success(data)
        case 400: return .failure(.badRequest)
        case 500: return .failure(.serverError)
        default: return .failure(.networkFail)
        }
    }
}
