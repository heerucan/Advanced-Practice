//
//  MemoViewController.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/03.
//

import UIKit

final class MemoViewController: UIViewController, MemoViewProtocol {
    
    enum Section: CaseIterable, Hashable {
        case main
    }
    
    // MARK: - Property
    
    let memo = [Memo(content: "첫 번째 메모"), Memo(content: "두 번째 메모")]
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Memo>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
    
    private lazy var memoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "메모리스트"
        memoCollectionView.backgroundColor = .white
        configureLayout()
        configureDataSource()
    }
    
    private func configureLayout() {
        view.addSubview(memoCollectionView)
        memoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        memoCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        memoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        memoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        memoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: - Method
    
    func addMemo(memo: Memo) {
        
    }
    
    func deleteMemo(index: Int) {
        
    }
    
    func updateMemo(index: Int, content: String) {
        
    }
    
}

// MARK: - Compositional Layout & DiffableDataSource

extension MemoViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MemoCollectionViewCell, Memo> {
            cell, indexPath, itemIdentifier in
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: memoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.contentLabel.text = itemIdentifier.content
            return cell
        })
        
        snapshot.appendSections([Section.main])
        snapshot.appendItems(memo)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
