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
    let urls: Urls
    let likes: Int
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, urls, likes
        case description = "description"
    }
}

// MARK: - Urls

struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
