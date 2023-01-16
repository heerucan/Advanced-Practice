//
//  ViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/07.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let valueLabel = UILabel()
    let tapButton = UIButton()
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraint()
        bind()
    }
    
    func setupUI() {
        valueLabel.text = ""
        valueLabel.font = .boldSystemFont(ofSize: 20)
        tapButton.backgroundColor = .green
        tapButton.setTitle("눌러라", for: .normal)
        textField.borderStyle = .roundedRect
        textField.becomeFirstResponder()
    }
    
    func setupConstraint() {
        view.addSubview(valueLabel)
        view.addSubview(tapButton)
        view.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tapButton.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    
    func bind() {
        
        tapButton.rx.tap
            .withUnretained(self)
            .map { _ in "Hello, RxCocoa" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 텍스트필드는 text 속성이 업데이트 되면 next event를 방출
        // UI 관련 코드는 Main Thread에 동작시켜야 하니까
        textField.rx.text
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
