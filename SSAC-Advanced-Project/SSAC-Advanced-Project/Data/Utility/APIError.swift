//
//  APIError.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

@frozen
enum APIError: Error {
    case badRequest
    case serverError
    case networkFail
}
