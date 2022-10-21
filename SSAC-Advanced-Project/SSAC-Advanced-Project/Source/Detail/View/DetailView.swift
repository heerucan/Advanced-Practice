//
//  DetailView.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

final class DetailView: BaseView {
    
    // MARK: - Property
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
    }
    
    let usernameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.text = "게시자이름"
    }
    
    let likeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemPink
        $0.text = "좋아요수"
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureLayout() {
        addSubviews([profileImageView,
                     usernameLabel,
                     likeLabel,
                     imageView,
                     collectionView])
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(5)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setupCollectionView(_ delegate: UICollectionViewDelegate) {
//        collectionView.register(DetailSupplementaryView.self,
//                                forSupplementaryViewOfKind: DetailViewController.sectionFooterElementKind,
//                                withReuseIdentifier: DetailSupplementaryView.reuseIdentifier)
        collectionView.delegate = delegate
    }
}

// MARK: - Compositional Layout

extension DetailView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let spacing = 5.0
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(self.frame.width-30),
                heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item, count: 1)
            
//            let headerSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .fractionalHeight(10))
//            let header = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: headerSize,
//                elementKind: DetailViewController.sectionFooterElementKind,
//                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
//            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .groupPagingCentered
            return section
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
        layout.configuration = config
        return layout
    }
}
