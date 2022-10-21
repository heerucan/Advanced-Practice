//
//  DetailSupplementaryView.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import UIKit

import SnapKit
import Then

final class DetailSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    // MARK: - Propery
    
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.text = "사용자가 게시한 작업물"
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureLayout() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
