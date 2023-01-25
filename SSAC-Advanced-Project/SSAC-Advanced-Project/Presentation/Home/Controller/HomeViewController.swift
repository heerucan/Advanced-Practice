//
//  HomeViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/11/02.
//

import UIKit

import RxSwift
import RxCocoa

protocol HomeViewDelegate: AnyObject {
    func logout() // finish Home Scene
}

final class HomeViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let homeView: HomeView
    var homeViewModel: HomeViewModel
    
    weak var homeViewDelegate: HomeViewDelegate?
    
    init(view: HomeView, viewModel: HomeViewModel) {
        self.homeView = view
        self.homeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(logoutTap: homeView.logoutButton.rx.tap)
        let output = homeViewModel.transform(input: input)
        
        output.logoutTap
            .withUnretained(self)
            .subscribe { vc,_ in
                vc.homeViewDelegate?.logout()
            }
            .disposed(by: disposeBag)
    }
}
