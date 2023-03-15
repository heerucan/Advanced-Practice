//
//  Movie.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/15.
//

import Foundation

struct Movie: Codable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: BoxOffice
}

struct BoxOffice: Codable {
    let dailyBoxOffice: [DailyBoxOffice]
}

struct DailyBoxOffice: Codable {
    let rank: Int
    let movieNm: String
    let openDt: String
    
    enum CodingKeys: String, CodingKey {
        case rank = "rank"
        case movieNm = "movieNm"
        case openDt = "openDt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rank = try container.decode(Int.self, forKey: .rank)
        movieNm = try container.decode(String.self, forKey: .movieNm)
        openDt = try container.decode(String.self, forKey: .openDt)
    }
}
