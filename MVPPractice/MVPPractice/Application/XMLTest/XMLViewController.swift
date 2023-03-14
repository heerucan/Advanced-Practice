//
//  XMLViewController.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/14.
//

import UIKit

final class XMLViewController: UIViewController {
    
    private var xmlParser = XMLParser()
    private var element = "" // 태그가 들어갈 변수
    private var movieItems = [[String: String]]()
    private var movieItem = [String: String]()
    private var movieTitle = ""
    private var content = ""
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let requestButton: UIButton = {
        let view = UIButton()
        view.setTitle("요청하기", for: .normal)
        view.backgroundColor = .blue
        view.layer.cornerRadius = 10
        view.addTarget(self, action: #selector(touchupRequestButton), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIandLayout()
    }
    
    // MARK: - Set up UI and Layout
    
    private func setupUIandLayout() {
        view.addSubview(tableView)
        view.addSubview(requestButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        requestButton.translatesAutoresizingMaskIntoConstraints = false
  
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: requestButton.topAnchor, constant: -20).isActive = true
        requestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        requestButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        requestButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        requestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        
        navigationItem.title = "요청하기 버튼을 누르세요."
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - @objc
    
    @objc private func touchupRequestButton() {
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=f5eef3421c602c6cb7ea224104795888&targetDt=20230301"
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else {
            return print("url error")
        }
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

// MARK: - XML Parsing

extension XMLViewController: XMLParserDelegate {
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
            tableView.reloadData()
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

// MARK: - TableView Delegate, DataSource

extension XMLViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = movieItems[indexPath.row]["movieNm"]
        cell.detailTextLabel?.text = movieItems[indexPath.row]["openDt"]
        return cell
    }
}
