//
//  XMLViewController.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/14.
//

import UIKit

import XMLCoder

final class XMLViewController: UIViewController {
    
    // MARK: - Property
    
    private let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=f5eef3421c602c6cb7ea224104795888&targetDt=20230301"
    
    private let xmlParserManager = XMLParserManager()
    
    private var movieItems = [[String: String]]()
    private var dailyBoxOfficeList = [DailyBoxOffice]()
    
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
        getData()
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
    
    // MARK: - XMLCoder Parsing Method

    private func getData() {
        dailyBoxOfficeList = []
        let movie = try! XMLDecoder().decode(Movie.self, from: Data(contentsOf: URL(string: url)!))
        dailyBoxOfficeList.append(contentsOf: movie.dailyBoxOfficeList.dailyBoxOffice)
        tableView.reloadData()
    }
    
    // MARK: - @objc
    
    @objc private func touchupRequestButton() {
        xmlParserManager.getData(url: url)
        movieItems = xmlParserManager.movieItems
    }
}

// MARK: - TableView Delegate, DataSource

extension XMLViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyBoxOfficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = dailyBoxOfficeList[indexPath.row].movieNm
        cell.detailTextLabel?.text = dailyBoxOfficeList[indexPath.row].openDt
        return cell
    }
}
