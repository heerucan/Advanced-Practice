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

protocol LoginCoordinatorDelegate {
    func didFinish(from coordinator: Coordinator)
}

final class LoginCoordinator: BaseCoordinator, LoginViewDelegate {
    
    override func start() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(view: LoginView(), viewModel: loginViewModel)
        loginViewController.navigationItem.title = "Login"
        loginViewController.loginViewDelegate = self
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
    
    // LoginViewDelegate의 함수
    func goToHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.loginCoordinatorDelegate = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

extension LoginCoordinator: LoginCoordinatorDelegate {
    /// 여기에 삭제할 자식 코디네이터를 매개변수로 전달해주면 된다.
    func didFinish(from coordinator: Coordinator) {
        print("삭제할 자식 코디네이터 전달 받았다!", coordinator)
        removeChildCoordinator(coordinator)
        debugPrint(childCoordinators)
    }
}
