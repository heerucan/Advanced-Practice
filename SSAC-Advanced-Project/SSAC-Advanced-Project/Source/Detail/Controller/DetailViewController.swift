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
    
    var usernameId = ""
    
    private let detailView = DetailView()
    private let detailViewModel = DetailViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photo>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindData()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "상세"
    }

    // MARK: - Bind Data
    
    private func bindData() {
        detailViewModel.requestUser(username: usernameId)
        detailViewModel.requestUserPhoto(username: usernameId)

        detailViewModel.userList.bind { user in
            DispatchQueue.main.async {
                self.detailView.setData(data: user)
            }
        }
        
        detailViewModel.photoList.bind { photo in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo)
            self.dataSource.apply(snapshot)
        }
    }
}

// MARK: - DiffableDataSource

extension DetailViewController {
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<DetailCollectionViewCell, Photo> { cell, indexPath, itemIdentifier in
            cell.setData(data: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<DetailSupplementaryView>(elementKind: DetailViewController.sectionHeaderElementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = self.usernameId + "의 작업물"
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
    }
}
