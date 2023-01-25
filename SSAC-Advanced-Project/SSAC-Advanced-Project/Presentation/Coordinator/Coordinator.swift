//
//  Coordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func start() {
        preconditionFailure("오버라이드해서 사용")
    }
    
    func finish() {
        preconditionFailure("오버라이드해서 사용")
    }
    
    // 파라미터로 전달된 coordinator를 추가
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        } else {
            print("coordinator 삭제 실패", coordinator)
        }
    }
}
