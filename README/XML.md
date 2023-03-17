
# XMLParsing Practice

![Untitled](https://user-images.githubusercontent.com/63235947/225204184-5a43dd53-a343-47ac-975c-2a29f02ff29f.png)

## 0. XML
**eXtensible Markup Language**

태그를 통해 데이터를 표현

XML을 사용하는 이유는, JSON 사용 이유와 동일 

- 실시간으로 변하는 데이터를 전송하는 RSS에 많이 사용 / 프로그램 설정파일
- 각 플랫폼마다 다루는 언어가 다르기 때문에 **중간 지점의 타협점**

<br>

## 1. XMLParser

[https://developer.apple.com/documentation/foundation/xmlparser](https://developer.apple.com/documentation/foundation/xmlparser)

- items을 파싱하고, 파싱에러 검출
- `thread-safe하다`. 왜냐면, 하나의 스레드에서만 사용됨
    - iOS는 멀티스레딩 방식 - 스택을 제외한 메모리 공간을 공유하기 때문에 한 스레드에서 사용 중인 곳을 다른 스레드가 접근하면 문제 발생
    - **즉, thread-safe는 여러 곳에 동시 접근하더라도 결과가 올바르다는 것**

<br>

## 1-1. XMLParserDelegate

```swift
// MARK: - XML Parsing

extension MemoViewController: XMLParserDelegate {
        // 태그 시작
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }

    // 태그 끝
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }

    // 태그 사이 문자열
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }

    // 에러 발생 시 사용
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
}
```

- 파싱을 멈출 때는 abortParsing()을 사용하면 
XMLParserDelegate의 parseErrorOccurred 메소드가 동작

<br>

### 1-1-1. XMLParser로 영화 정보 파싱

1. URL 타입의 매개변수(파싱할 xml)를 넣어서 XMLParser 객체를 생성하고
2. parse()를 통해서 넣어준 URL 응답을 파싱한다.
3. 파싱 받는 값은 XMLParserDelegate에서 로직을 구현한다.

```swift
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
```

```swift
//ViewController

private let xmlParserManager = XMLParserManager()
    
private var movieItems = [[String: String]]()

@objc private func touchupRequestButton() {
        xmlParserManager.getData(url: url)
        movieItems = xmlParserManager.movieItems
        print("🐷", movieItems)
}
```

<br>

![스크린샷 2023-03-15 오전 11 59 33](https://userimages.githubusercontent.com/63235947/225204181-4335e3ad-e875-41b0-bb00-d50b39b6c48c.png)

<br>

## 2-1. XMLCoder

날아라 자막에서 사용하는 XMLParsing 라이브러리 https://github.com/CoreOffice/XMLCoder

<br>

### 2-1-2. XMLDecoder로 영화 정보 파싱

xml을 확인하고 구조체로 구조를 만들어줘야 한다.

이때 트리구조에 맞게 구조체를 다 만들어줘야 하고, 여러 데이터들 중에 특정 데이터만 받을 경우에는 가장 내부에 있는 태그들 중 일부만 작성해주면 되고,

그 중에 데이터가 없는 경우도(즉, nil인 경우) 있기 때문에 DecodingError를 방지하려면 `decodeIfpresent`를 사용해서 처리

옵셔널 타입으로 처리해도 되긴 함

<br>

![스크린샷 2023-03-15 오전 11 13 27](https://user-images.githubusercontent.com/63235947/225204176-98a3893e-e817-436f-b713-e34eeb919479.png)

<br>

```swift
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
```

라이브러리 도큐에 사용법 잘 나와있음

```swift
private let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=f5eef3421c602c6cb7ea224104795888&targetDt=20230301"
private var dailyBoxOfficeList = [DailyBoxOffice]()

private func getData() {
        dailyBoxOfficeList = []
        let movie = try! XMLDecoder().decode(Movie.self, from: Data(contentsOf: URL(string: url)!))
        dailyBoxOfficeList.append(contentsOf: movie.dailyBoxOfficeList.dailyBoxOffice)
        tableView.reloadData()
}
```
<br>

![스크린샷 2023-03-15 오전 11 33 51](https://user-images.githubusercontent.com/63235947/225204178-1ed601b1-2354-4d3f-9a85-f65fc275e19f.png)



## 3. 참고자료

[https://swycha.tistory.com/180](https://swycha.tistory.com/180)
