//
//  Music.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/03.
//

import Foundation

/*
 Music에 대한 정보를 가지고 있는 Model
 */
struct Music {
    let title: String
    let singer: String
    let file: String
}

/*
 Music 목록에 대한 정보를 가지고 있는 Model
 */
struct MusicList {
    let musics: [Music]
}
