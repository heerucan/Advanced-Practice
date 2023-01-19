//
//  NetworkCommon.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/19.
//

import Foundation

let booksUrlStr = "https://kxcoding-study.azurewebsites.net/api/books"
let stringValueUrlStr = "https://kxcoding-study.azurewebsites.net/api/string"

struct Book: Codable {
    let id: Int
    let title: String
    let desc: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case link = "yes24Link"
    }
}


struct BookList: Codable {
    let list: [Book]
    let totalCount: Int
    let code: Int
    let message: String?
    
    // data를 받아서 디코딩해서 Book 배열로 반환
    static func parse(data: Data) -> [Book] {
        var list = [Book]()
        
        do {
            let decoder = JSONDecoder()
            let bookList = try decoder.decode(BookList.self, from: data)
            
            if bookList.code == 200 {
                list = bookList.list
            }
        } catch {
            print(error)
        }
        
        return list
    }
    
    // json을 받아서 Book 배열로 반환
    static func parse(json: Any) -> [Book] {
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        return parse(data: data)
    }
}

