//
//  Profile.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import Foundation

// MARK: - Profile

struct Profile: Codable {
    let auth: Auth
}

// MARK: - Auth

struct Auth: Codable {
    let photo, email, username: String

    enum CodingKeys: String, CodingKey {
        case photo, email, username
    }
}
