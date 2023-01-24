//
//  BaseViewController.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController, BaseMethodProtocol {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        setupDelegate()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure UI & Layout
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureLayout() { }
    func setupDelegate() { }
    func bindViewModel() { }
}
