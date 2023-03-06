//
//  Memo.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/03.
//

import Foundation

/*
 Memo에 대한 정보를 가지고 있는 Model
 */
struct Memo: Hashable {
    let id = UUID()
    let content: String
}
