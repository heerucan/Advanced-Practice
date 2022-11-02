//
//  User.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

// MARK: - User

struct User: Decodable, Hashable {
    let id: String
    let username: String
    let profileImage: ProfileImage
    let totalPhotos: Int
    let photos: [Photo]

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profileImage = "profile_image"
        case totalPhotos = "total_photos"
        case photos
    }
}

// MARK: - Photo

struct Photo: Decodable, Hashable {
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case urls
    }
}

// MARK: - Urls

struct Urls: Decodable, Hashable {
    let regular: String

    enum CodingKeys: String, CodingKey {
        case regular
    }
}

// MARK: - ProfileImage

struct ProfileImage: Decodable, Hashable {
    let large: String
}
