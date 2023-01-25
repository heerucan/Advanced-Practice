//
//  LoginViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

import RxSwift
import RxCocoa

// 사용자가 버튼을 눌러 화면을 전환해줘!라는 신호를 이를 통해 전달
protocol LoginViewDelegate: AnyObject {
    func goToHome()
}

final class LoginViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let loginView: LoginView
    var loginViewModel: LoginViewModel
    
    weak var loginViewDelegate: LoginViewDelegate?
    
    init(view: LoginView, viewModel: LoginViewModel) {
        self.loginView = view
        self.loginViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func configureUI() {
        super.configureUI()
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = LoginViewModel.Input(loginTap: loginView.loginButton.rx.tap)
        let output = loginViewModel.transform(input: input)
        
        output.loginTap
            .withUnretained(self)
            .subscribe { vc,_ in
                vc.loginViewDelegate?.goToHome()
            }
            .disposed(by: disposeBag)
    }
}
