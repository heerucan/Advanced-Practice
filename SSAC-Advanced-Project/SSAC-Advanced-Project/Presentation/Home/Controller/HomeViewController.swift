//
//  HomeViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let homeView = HomeView()
    private let homeViewModel = HomeViewModel()

    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .white
    }
    
    override func configureLayout() {
        
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}
