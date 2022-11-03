//
//  SignupViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let signupView = SignupView()
    private let signupViewModel = SignupViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .white
        
//        GenericAPIManager.shared.requestData(String.self, AuthRouter.signup("ru", "happyruhee@naver.com", "11111111")) { response in
//            print("회원가입", response)
//        }
        
        GenericAPIManager.shared.requestData(Login.self, AuthRouter.login("happyruhee@naver.com", "11111111")) { (result: Result<Login, APIError>) in
            switch result {
            case .success(let data):
                print(data.token)
                UserDefaults.standard.set(data.token, forKey: Matrix.token)
            case .failure(let error):
                print("로그인", error.localizedDescription)
            }
        }
        
        GenericAPIManager.shared.requestData(Profile.self, AuthRouter.profile) { (result: Result<Profile, APIError>) in
            print("루희루흐리")
            print(result)
            switch result {
            case .success(let data):
                print("이이이이ㅣ잉")
                print(data.myProfile.email, data.myProfile.username)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = SignupViewModel.Input()
        let output = signupViewModel.transform(input: input)
        
        // 닉네임 텍스트필드에 글을 입력할테니 (이벤트 전달할테니) -> 1글자 미만이면 닉네임텍스트필드 테두리색 빨갛게 바꿔라
        signupView.nameTextField.rx.text // Input
            .orEmpty
            .map { $0.count < 1 }
            .bind(to: signupView.signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signupView.emailTextField.rx.text
            .orEmpty
            .map { !$0.contains("@") }
            .bind(to: signupView.signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signupView.passwordTextField.rx.text
            .orEmpty
            .map { $0.count > 8 }
            .bind(to: signupView.signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signupView.signupButton.rx.tap
            .bind { _ in
                
            }
            .disposed(by: disposeBag)
        
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}
