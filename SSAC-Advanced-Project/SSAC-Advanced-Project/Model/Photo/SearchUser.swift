//
//  SearchUser.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import Foundation

// MARK: - SearchUser

struct SearchUser: Codable {
    let total, totalPages: Int
    let results: [SearchResult]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result

struct SearchResult: Codable, Hashable {
    let id: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
    }
}
