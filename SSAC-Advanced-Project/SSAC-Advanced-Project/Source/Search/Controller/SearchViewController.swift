//
//  SearchViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

final class SearchViewController: BaseViewController {
    
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

    override func setupDelegate() {
        searchView.setupDelegate(self, self)
    }
    
    // MARK: - Bind
    
    private func bindData() {
        print(#function)
        searchViewModel.userList.bind { user in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Result>()
            snapshot.appendSections([0])
            snapshot.appendItems(user.results)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        searchViewModel.requestSearchUser(query: query)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
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
