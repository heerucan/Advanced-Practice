//
//  MemoCollectionViewCell.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/06.
//

import UIKit

final class MemoCollectionViewCell: UICollectionViewCell {
    static let identifier = "MemoCollectionViewCell"
    
    // MARK: - Property
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .left
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureLayout() {
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20).isActive = true
    }
}
