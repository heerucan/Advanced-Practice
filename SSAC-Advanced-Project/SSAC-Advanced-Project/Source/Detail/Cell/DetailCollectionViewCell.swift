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
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

