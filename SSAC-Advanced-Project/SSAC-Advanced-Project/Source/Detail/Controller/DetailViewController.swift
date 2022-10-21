//
//  DetailViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    // MARK: - Property
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private let detailView = DetailView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "상세"
        PhotoAPIManager.shared.getSearchUser(query: "apple") { (data, status, error) in
            print("getSearchUser", data, status, error)
        }
        
        PhotoAPIManager.shared.getUserPhoto(username: "apple") { (data, status, error) in
            print("getUserPhoto", data, status, error)
        }
        
        PhotoAPIManager.shared.getUser(username: "apple") { (data, status, error) in
            print("user", data, status, error)
        } 
    }
    
    override func setupDelegate() {
        detailView.setupCollectionView(self)
    }

    // MARK: - Bind Data
    
    override func bindData() {
        print(#function)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {
    
}

// MARK: - DiffableDataSource

extension DetailViewController {
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<DetailCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.backgroundColor = .lightGray
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<DetailSupplementaryView>(elementKind: DetailViewController.sectionHeaderElementKind) { supplementaryView, elementKind, indexPath in
        }
       
        dataSource = UICollectionViewDiffableDataSource(collectionView: detailView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.detailView.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["dk", "D", "A", "GAS"], toSection: 0)
        dataSource.apply(snapshot)
    }
}
