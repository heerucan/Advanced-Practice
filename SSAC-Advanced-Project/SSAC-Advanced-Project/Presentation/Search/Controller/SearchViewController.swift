//
//  SearchViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "검색"
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = SearchViewModel.Input(searchText: searchView.searchBar.rx.text)
        let output = searchViewModel.transform(input: input)
        
        searchViewModel.userList // Output VM -> VC
            .withUnretained(self)
            .bind { (vc, user) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
                snapshot.appendSections([0])
                snapshot.appendItems(user.results)
                vc.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
        
        output.searchText
            .withUnretained(self)
            .bind(onNext: { (vc, value) in
                vc.searchViewModel.requestSearchUser(query: value, page: 50)
            })
            .disposed(by: disposeBag)
        
        searchView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { (vc, item) in
                vc.pushDetailView(item)
                vc.searchView.collectionView.deselectItem(at: item, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushDetailView(_ indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let viewController = DetailViewController()
        viewController.usernameId = item.username
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - DiffableDataSource

extension SearchViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            var back = UIBackgroundConfiguration.listPlainCell()
            content.text = itemIdentifier.username
            content.textProperties.alignment = .center
            back.strokeWidth = 1
            back.strokeColor = .black
            cell.backgroundConfiguration = back
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}
