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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    // MARK: - Configure UI & Layout

    override func setupDelegate() {
        searchView.setupDelegate(self, self)
    }
    
    // MARK: - Bind
    
    override func bindData() {
        print(#function)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
    }
}

// MARK: - DiffableDataSource

extension SearchViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            // String > URL > Data > Image 방식
            
//            cell.imageView.image.
            cell.backgroundColor = .red
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 2
        }
    
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["안녕", "안d녕", "안ss녕", "안a녕", "안g녕", "안s녕", "안gh녕"])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
