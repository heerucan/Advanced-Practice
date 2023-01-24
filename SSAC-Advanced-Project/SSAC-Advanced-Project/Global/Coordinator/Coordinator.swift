//
//  Coordinator.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2023/01/24.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
