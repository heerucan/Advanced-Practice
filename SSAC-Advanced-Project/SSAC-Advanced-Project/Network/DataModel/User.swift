//
//  User.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

// MARK: - User

struct User: Codable {
    let id: String
    let username: String
    let profileImage: ProfileImage
    let totalPhotos: Int

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profileImage = "profile_image"
        case totalPhotos = "total_photos"
    }
}

// MARK: - ProfileImage

struct ProfileImage: Codable {
    let small, medium, large: String
}
