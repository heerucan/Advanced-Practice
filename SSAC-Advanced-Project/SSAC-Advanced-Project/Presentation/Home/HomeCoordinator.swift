//
//  HomeCoordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/25.
//

import UIKit

final class HomeCoordinator: BaseCoordinator {
    
    var loginCoordinatorDelegate: LoginCoordinatorDelegate?
    
    var homeNavigationController: UINavigationController?
    let homeViewModel = HomeViewModel()
    lazy var homeViewController = HomeViewController(view: HomeView(), viewModel: homeViewModel)
        
    override func start() {
        
        homeViewController.homeViewDelegate = self
        // 기존 LoginViewController에서 화면전환이 이루어지고 있는 navigationController 대신 새로운 로그인 플로우를 위해
        // 새로운 네비게이션 컨트롤러를 가지게 구현
        homeNavigationController = UINavigationController(rootViewController: homeViewController)
        guard let homeNavigationController = homeNavigationController else { return }
        homeNavigationController.modalPresentationStyle = .fullScreen
        
        // 이 navigationController는 초기화 시에 LoginCoordinator에서 인자로 전달받는 navigationController
        // 전달 받은 네비컨트롤러에 homeNavi~Controller를 present
        navigationController.present(homeNavigationController, animated: true)
    }
    
    override func finish() {
        // LoginCoordinator에게 매개변수로 자기자신(HomeCoordinator)을 넣어서 전달
        loginCoordinatorDelegate?.didFinish(from: self)
    }
}

extension HomeCoordinator: HomeViewDelegate {
    // HomeVC의 Logout을 호출하면 이 코드가 동작
    func logout() {
        guard let homeNavigationController = homeNavigationController else { return }
        homeNavigationController.dismiss(animated: true) {
            self.finish() // child Coordinator를 삭제하는 로직
        }
    }
}
