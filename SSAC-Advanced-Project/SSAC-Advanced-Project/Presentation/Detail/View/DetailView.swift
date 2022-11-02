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
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 40
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
    }
    
    let usernameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let subLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        addSubviews([profileImageView,
                     usernameLabel,
                     subLabel,
                     collectionView])
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).inset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).inset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(50)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func setupCollectionView() {
        collectionView.register(DetailSupplementaryView.self,
                                forSupplementaryViewOfKind: DetailViewController.sectionHeaderElementKind,
                                withReuseIdentifier: DetailSupplementaryView.reuseIdentifier)
    }
    
    // MARK: - Set Data
    
    func setData(data: User) {
        guard let url = URL(string: data.profileImage.large) else { return }
        guard let userData = try? Data(contentsOf: url) else { return }
        profileImageView.image = UIImage(data: userData)
        usernameLabel.text = data.username
        subLabel.text = "좋아요 수 \(data.totalPhotos)"
    }
}

// MARK: - Compositional Layout

extension DetailView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let spacing = 10.0
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(self.frame.width-30),
                heightDimension: .fractionalHeight(9/10))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 1)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: DetailViewController.sectionHeaderElementKind,
                alignment: .top)
            header.contentInsets = NSDirectionalEdgeInsets(
                top: 20, leading: 20, bottom: 0, trailing: 20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .groupPagingCentered
            return section
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
        layout.configuration = configuration
        return layout
    }
}
