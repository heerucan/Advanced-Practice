//
//  GithubViewController.swift
//  ArchitecturePractice
//
//  Created by heerucan on 2023/03/22.
//

import UIKit

import SafariServices
import ReactorKit
import RxCocoa

/*
 키워드 검색 시 관련 깃허브 리스트를 보여주고
 누르면 깃허브 웹페이지 띄워주는 기능
 
 <어떤 방식으로 먼저 코드를 작성할 건지 처리 순서>
 1. Action, Mutate, State에 어떤 데이터가 있어야 할 것인지 생각할 것
 2. 
 */

final class GithubViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
        
    // MARK: - Property
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Init
    
    init(reactor: GithubReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    // MARK: - UI, Layout
    
    private func setupUI() {
        tableView.backgroundColor = .white
        tableView.verticalScrollIndicatorInsets.top = tableView.contentInset.top
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Github Search"
        navigationItem.searchController = searchController
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Bind
    
    func bind(reactor: GithubReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: GithubReactor) {

        /// 사용자 검색
        searchController.searchBar.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        /// 스크롤
        tableView.rx.contentOffset
            .withUnretained(self)
            .filter { vc, offset in // filter는 특정 조건에 맞는 항목만 필터링
                guard vc.tableView.frame.height > 0 else { return false }
                return offset.y + vc.tableView.frame.height >= vc.tableView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: GithubReactor) {
        
        // tableView 세팅
        reactor.state
            .map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, repo, cell in
                cell.textLabel?.text = repo
            }
            .disposed(by: disposeBag)
        
        // tableView 선택 시 safari present
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, indexPath in
                vc.view.endEditing(true)
                vc.tableView.deselectRow(at: indexPath, animated: false)
                let repo = reactor.currentState.repos[indexPath.row]
                guard let url = URL(string: "https://github.com/\(repo)") else { return }
                let viewController = SFSafariViewController(url: url)
                vc.searchController.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
