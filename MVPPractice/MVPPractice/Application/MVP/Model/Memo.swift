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

//struct Memo: Hashable {
//    let id = UUID()
//    var contents: [String]
//
//    init(content: String) {
//        self.contents = [content]
//    }
//
//    mutating func addMemo(_ memo: Memo) {
//        self.contents.append(contentsOf: memo.contents)
//    }
//}

struct Memo: Hashable {
    let id = UUID()
    var contents: [String]
    
    mutating func addMemo(_ memo: Memo) {
        self.contents.append(contentsOf: memo.contents)
    }
}
