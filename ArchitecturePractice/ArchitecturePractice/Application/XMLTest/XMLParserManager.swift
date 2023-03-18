//
//  XMLParserManager.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/15.
//

import Foundation

final class XMLParserManager: NSObject, XMLParserDelegate {
    
    private var xmlParser = XMLParser()
    private var element = "" // 태그가 들어갈 변수
    var movieItems = [[String: String]]() // 태그 내에 여러개의 데이터들이 들어있을 수 있음 - <row></row>가 여러개
    private var movieItem = [String: String]()
    private var movieTitle = ""
    private var content = ""
    
    func getData(url: String) {
        movieItems = []
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else {
            return print("url error")
        }
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("========== 태그 시작 ===========", parser.lineNumber, elementName)
        element = elementName
        if elementName == "dailyBoxOffice" {
            movieItem = [String: String]()
            // 한 번 파싱 후 변수에 들어있는 값 비워주기
            movieTitle = ""
            content = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("========== 태그 끝 ===========", parser.lineNumber, elementName)
        if elementName == "dailyBoxOffice" {
            movieItem["movieNm"] = movieTitle
            movieItem["openDt"] = content
            movieItems.append(movieItem)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("========== 태그 사이 문자열 ===========")
        if element == "openDt" {
            content = string
        } else if element == "movieNm" {
            movieTitle = string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("========== 파싱 중 오류 ===========", parseError)
    }
}
