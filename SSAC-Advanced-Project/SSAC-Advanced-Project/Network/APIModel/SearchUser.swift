//
//  SearchUser.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import Foundation

// MARK: - SearchUser

struct SearchUser: Decodable {
    let total, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result

struct Result: Decodable, Hashable {
    let id: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
    }
}
