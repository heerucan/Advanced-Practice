//
//  DetailViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    var usernameId = ""
    
    private let detailView = DetailView()
    private let detailSupplementaryView = DetailSupplementaryView()
    private let detailViewModel = DetailViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photo>!
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "상세"
    }

    // MARK: - Bind Data
    
    private func bindViewModel() {
        
        // 이벤트를 전달하는 객체 : 옵저버블 - viewmodel의 userList
        // 이벤트를 전달받는 객체 : 옵저버 - view의 userNameLabel, subLabel 등등
        // 그리고 bind는 항상 Main에서 작동하니까 Main 큐 처리를 해주지 않아도 될 듯..?
        
        let input = DetailViewModel.Input()
        let output = detailViewModel.transform(input: input)
        
        output.userList // Output VM -> VC
            .withUnretained(self)
            .bind { (vc, data) in
                vc.detailView.setData(data: data)
            }
            .disposed(by: disposeBag)

        output.photoList // Output VM -> VC
            .withUnretained(self)
            .bind { (vc, photo) in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo)
            vc.dataSource.apply(snapshot)
        }
        .disposed(by: disposeBag)
        
        detailViewModel.requestUser(username: usernameId)
        detailViewModel.requestUserPhoto(username: usernameId)
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
