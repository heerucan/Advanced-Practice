//
//  DetailCollectionViewCell.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import UIKit

final class DetailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.text = "제목"
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([imageView,
                                 titleLabel])
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(15)
        }
    }
}

