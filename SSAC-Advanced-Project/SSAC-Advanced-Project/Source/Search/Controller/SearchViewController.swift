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
    private var dataSource: UICollectionViewDiffableDataSource<Int, Result>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindData()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "검색"
    }
    
    // MARK: - Bind
    
    private func bindData() {
        
        searchViewModel.userList
            .withUnretained(self)
            .bind { (vc, user) in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Result>()
            snapshot.appendSections([0])
            snapshot.appendItems(user.results)
            vc.dataSource.apply(snapshot, animatingDifferences: true)
        }
        .disposed(by: disposeBag)
        
        searchView.searchBar.searchTextField.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.searchViewModel.requestSearchUser(query: value, page: 50)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
    
        searchView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { (vc, item) in
                vc.pushDetailView(item)
                vc.searchView.collectionView.deselectItem(at: item, animated: true)
            }, onError: { error in
                print(error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Result> { cell, indexPath, itemIdentifier in
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
