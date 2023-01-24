//
//  HomeView.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

final class HomeView: BaseView {
    
    // MARK: - Property
    
    private let welcomeLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 50)
        $0.text = "HOME"
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.backgroundColor = .systemOrange
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
    }
    
    private let searchButton = UIButton().then {
        $0.setTitle("스플래시 검색하기", for: .normal)
        $0.backgroundColor = .systemOrange
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        addSubviews([welcomeLabel,
                     logoutButton,
                     searchButton])
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(250)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(30)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(30)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}
