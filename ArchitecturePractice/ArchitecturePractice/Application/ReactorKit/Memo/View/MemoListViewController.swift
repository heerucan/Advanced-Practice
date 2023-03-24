//
//  MemoListViewController.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/13.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MemoListViewController: UIViewController, View {
    
    typealias Reactor = <#T##Type#>
    typealias MemoDataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias MemoSnapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var disposeBag = DisposeBag()
    var dataSource: MemoDataSource!
        
    // MARK: - UI
    
    private lazy var memoCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(MemoListCollectionViewCell.self, forCellWithReuseIdentifier: MemoListCollectionViewCell.identifier)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var addButton = UIBarButtonItem(systemItem: .add)
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupLayout()
        configureDataSource()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "메모리스트"
        navigationItem.rightBarButtonItem = addButton
        memoCollectionView.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        view.addSubview(memoCollectionView)
        memoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        memoCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        memoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        memoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        memoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension MemoListViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] action, view, completion in
                guard let self = self else { return }

            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MemoCollectionViewCell, String> {
            cell, indexPath, itemIdentifier in
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: memoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.contentLabel.text = itemIdentifier
            return cell
        })
        snapshot.appendSections([Section.main])
//        snapshot.appendItems(memoList.contents)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
