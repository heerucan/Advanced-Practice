//
//  AppCoordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/24.
//

import UIKit

class AppCoordinator: Coordinator {
    var childrenCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    // SceneDelegate에서 인자값으로 받은 값
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self // LoginViewModel의 coordinator를 AppCoordinator로 설정
        
        let loginViewController = LoginViewController(view: LoginView(), viewModel: loginViewModel)
        loginViewController.loginViewModel = loginViewModel // LoginViewController의 viewModel도 LoginViewModel로 설정
        
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func goToHomeVC() {
        let homeViewModel = HomeViewModel()
        homeViewModel.coordinator = self
        
        let homeViewController = HomeViewController(view: HomeView(), viewModel: homeViewModel)
        homeViewController.homeViewModel = homeViewModel
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
