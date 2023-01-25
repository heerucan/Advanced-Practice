//
//  AppCoordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/24.
//

import UIKit

/*
 최상위 Coordinator
 Child Coordinator로 LoginCoordinator가 있다.
 */
class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator? = nil
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let window: UIWindow?
    
    // SceneDelegate로부터 전달 받음
    init(window: UIWindow?) {
        navigationController = UINavigationController()
        self.window = window
        self.window?.rootViewController = navigationController
        self.window?.backgroundColor = .red
    }
    
    func start() {
        guard let window = window else { return }
        window.makeKeyAndVisible()
        /// 여기서 enum과 Switch문으로 자동로그인이 있는 경우 - LoginVC or HomeVC으로 나눠줄 수 있다.
        goToLoginVC()
    }
    
    func goToLoginVC() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self // 부모 코디네이터가 바로 AppCoordinator 자신이라는 것을 알림
        addChildCoordinator(loginCoordinator) // 자식 코디네이터로 LoginCoordinator를 추가함
        loginCoordinator.start()
    }
}
