//
//  BaseCoordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/25.
//

import UIKit

class BaseCoordinator: Coordinator {
    var parentCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("Start method must be implemented")
    }
    
    func finish() {
        fatalError("Finish method must be implemented")
    }
}
