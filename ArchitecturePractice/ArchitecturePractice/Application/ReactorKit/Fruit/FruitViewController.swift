//
//  FruitViewController.swift
//  ArchitecturePractice
//
//  Created by heerucan on 2023/03/19.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class FruitViewController: UIViewController, View {
    
    // MARK: - DisposeBag
    
    var disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private lazy var appleButton = UIButton()
    private lazy var bananaButton = UIButton()
    private lazy var pineappleButton = UIButton()
    private lazy var resultLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [
        appleButton, bananaButton, pineappleButton, resultLabel
    ])
    
    // MARK: - Init
    
    init(reactor: FruitViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
    }
    
    // MARK: - UI & Layout
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 30
        stackView.distribution = .equalSpacing
        appleButton.setTitleColor(.blue, for: .normal)
        bananaButton.setTitleColor(.blue, for: .normal)
        pineappleButton.setTitleColor(.blue, for: .normal)
        appleButton.setTitle("사과", for: .normal)
        bananaButton.setTitle("바나나", for: .normal)
        pineappleButton.setTitle("파인애플", for: .normal)
        resultLabel.text = "과일을 선택하세요"
        resultLabel.font = .systemFont(ofSize: 20)
    }
    
    // MARK: - Bind
    
    func bind(reactor: FruitViewReactor) {
        
        // action input
        appleButton.rx.tap
            .map { Reactor.Action.apple }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bananaButton.rx.tap
            .map { Reactor.Action.banana }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pineappleButton.rx.tap
            .map { Reactor.Action.pineapple }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // state output
        reactor.state
            .map { $0.fruitName }
            .distinctUntilChanged()
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { vc, value in
                if value {
                    vc.resultLabel.text = "로딩 중..."
                }
            })
            .disposed(by: disposeBag)
    }
}
