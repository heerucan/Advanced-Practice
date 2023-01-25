//
//  LoginCoordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/25.
//

import UIKit

/*
 AppCoordinator의 Child Coordinator
 LoginCoordinator의 Parent Coordinator는 AppCoordinator
 */
class LoginCoordinator: BaseCoordinator {

    override func start() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(view: LoginView(), viewModel: loginViewModel)
        loginViewController.navigationItem.title = "Login"
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
}
