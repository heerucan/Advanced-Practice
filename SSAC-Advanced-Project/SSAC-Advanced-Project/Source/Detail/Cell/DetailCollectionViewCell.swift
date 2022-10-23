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
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray6
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
    
    // MARK: - Set Data
    
    func setData(data: Photo) {
        DispatchQueue.global().async {
            guard let url = URL(string: data.urls.regular) else { return }
            guard let photoData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: photoData)
            }
        }
    }
}
