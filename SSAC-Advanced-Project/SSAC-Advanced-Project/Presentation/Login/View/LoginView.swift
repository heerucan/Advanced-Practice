//
//  LoginView.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseView {
    
    // MARK: - Property
    
    private let loginLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 25)
        $0.text = "로그인"
    }
    
    private lazy var fieldStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 17
    }
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력하세요"
        $0.clearButtonMode = .whileEditing
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호는 8자리 이상입니다"
        $0.isSecureTextEntry = true
        $0.clearButtonMode = .whileEditing
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
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
        addSubviews([loginLabel,
                     fieldStackView,
                     loginButton])
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        fieldStackView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(80)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(fieldStackView.snp.bottom).offset(50)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        [emailTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.snp.makeConstraints { make in
            make.height.equalTo(45)
        }}
    }
}
