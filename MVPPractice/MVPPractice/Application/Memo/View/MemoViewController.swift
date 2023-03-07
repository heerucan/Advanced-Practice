//
//  MemoViewController.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/03.
//

import UIKit

final class MemoViewController: UIViewController {
    
    private enum Section: CaseIterable, Hashable {
        case main
    }
    
    // MARK: - Property
    
    private var memoList = Memo(contents: ["하나", "둘", "셋"])
    private var presenter: MemoPresenterProtocol!
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    
    private lazy var memoCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout())
    
    private lazy var addButton = UIBarButtonItem(
        image: UIImage(systemName: "plus"),
        style: .plain,
        target: self,
        action: #selector(addButtonClicked(sender:)))
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureLayout()
        configureDataSource()
        presenter = MemoPresenter(view: self, model: memoList)
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "메모리스트"
        navigationItem.rightBarButtonItem = addButton
        memoCollectionView.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        view.addSubview(memoCollectionView)
        memoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        memoCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        memoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        memoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        memoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - @objc
    
    @objc func addButtonClicked(sender: UIBarButtonItem) {
        let alertVC = UIAlertController( title: "메모추가", message: "간단한 메모를 작성하세요", preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "ex. 알고리즘 풀기"
            textField.textColor = .black
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive) { _ in
            self.dismiss(animated: false)
        }
        let ok = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            if let title = alertVC.textFields?.first!.text, !title.isEmpty {
                // View로 사용자의 입력이 들어왔음 -> presenter에게 작업요청
                self?.presenter?.addButtonClicked(with: Memo(contents: [title]))
            }
        }
        alertVC.addAction(cancel)
        alertVC.addAction(ok)
        self.present(alertVC, animated: true)
    }
}

// MARK: - MemoViewProtocol Method

extension MemoViewController: MemoViewProtocol {
    func addMemo(memo: Memo) {
        // MemoPresenter에서 MemoViewProtocol의 메소드에 모델의 데이터를 넣어서 전달하면, View에서는 데이터를 받아서
        // VC의 memoList에 추가하는 방식
        snapshot.appendItems(memo.contents)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func deleteMemo(for indexPath: IndexPath, memo: Memo) {
        if let deleteItem = dataSource.itemIdentifier(for: indexPath) {
            snapshot.deleteItems([deleteItem])
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - Compositional Layout & DiffableDataSource

extension MemoViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] action, view, completion in
                guard let self = self else { return }
                self.presenter.deleteSelectedMemo(for: indexPath)
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
        snapshot.appendItems(memoList.contents)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
