//
//  Photo.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

// MARK: - Photo

struct Photo: Codable {
    let id: String
    let likes: Int

    enum CodingKeys: String, CodingKey {
        case id, likes
    }
}

// MARK: - User
struct User: Codable {
    let id: String
    let username: String
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}
