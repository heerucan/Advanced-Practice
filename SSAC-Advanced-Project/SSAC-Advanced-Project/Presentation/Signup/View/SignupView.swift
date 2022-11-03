//
//  SignupView.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

final class SignupView: BaseView {
    
    // MARK: - Property
    
    private let signupLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 25)
        $0.text = "회원가입"
    }
    
    private lazy var fieldStackView = UIStackView(
        arrangedSubviews: [nameTextField, emailTextField, passwordTextField]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 15
    }
    
    let nameTextField = UITextField().then {
        $0.placeholder = "이름을 입력해주세요"
        $0.clearButtonMode = .whileEditing
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.clearButtonMode = .whileEditing
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호는 8자리 이상입니다"
        $0.isSecureTextEntry = true
        $0.clearButtonMode = .whileEditing
    }
    
    let signupButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
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
        addSubviews([signupLabel,
                     fieldStackView,
                     signupButton])
        
        signupLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        fieldStackView.snp.makeConstraints { make in
            make.top.equalTo(signupLabel.snp.bottom).offset(80)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(fieldStackView.snp.bottom).offset(30)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        [nameTextField, emailTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.snp.makeConstraints { make in
            make.height.equalTo(45)
        }}
    }
    
    // MARK: - Custom Method
}
