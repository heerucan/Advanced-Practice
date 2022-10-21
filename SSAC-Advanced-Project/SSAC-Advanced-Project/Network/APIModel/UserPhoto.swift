//
//  UserPhoto.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import Foundation

// MARK: - UserPhoto

struct UserPhoto: Decodable {
    let id: String
    let urls: Urls
    let welcomeDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, urls
        case welcomeDescription = "description"
    }
}

// MARK: - Urls

struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
