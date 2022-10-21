//
//  UserPhoto.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

// MARK: - UserPhoto

struct UserPhoto: Codable {
    let id: String
    let welcomeDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case welcomeDescription = "description"
    }
}
