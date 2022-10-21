//
//  DetailViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    // MARK: - Property
    
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
    
    

    // MARK: - Bind Data
    
    override func bindData() {
        print(#function)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

// MARK: - DiffableDataSource

extension DetailViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DetailCollectionViewCell, String> { cell, indexPath, itemIdentifier in
//            cell.imageView
//            guard let cell
            cell.backgroundColor = .lightGray
            cell.layer.cornerRadius = 20
        }
       
        dataSource = UICollectionViewDiffableDataSource(collectionView: detailView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["dk", "D", "A", "GAS"])
        dataSource.apply(snapshot)
    }
}
