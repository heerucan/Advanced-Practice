//
//  BaseAPIManager.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

class BaseAPIManager {
    typealias Completion<T> = ((Result<T, APIError>) -> Void)
        
    func judgeStatus<T>(statusCode: Int, data: T) -> Result<T, APIError> {
        switch statusCode {
        case 200: return .success(data)
        case 400: return .failure(.badRequest)
        case 500: return .failure(.serverError)
        default: return .failure(.networkFail)
        }
    }
}
