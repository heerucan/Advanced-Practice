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
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result

struct Result: Codable {
    let id: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
        username = (try? values.decode(String.self, forKey: .username)) ?? ""
    }
}
