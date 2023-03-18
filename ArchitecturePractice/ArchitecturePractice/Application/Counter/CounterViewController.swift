//
//  CounterViewController.swift
//  ArchitecturePractice
//
//  Created by heerucan on 2023/03/18.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class CounterViewController: UIViewController, View {
    
    // MARK: - DisposeBag
    
    var disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let decreaseButton = UIButton()
    private let increaseButton = UIButton()
    private let valueLabel = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Init
    
    init(reactor: CounterViewReactor) {
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
    
    // MARK: - Layout & UI
    
    private func setupLayout() {
        view.addSubview(decreaseButton)
        view.addSubview(increaseButton)
        view.addSubview(valueLabel)
        view.addSubview(activityIndicatorView)
        
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        decreaseButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).isActive = true
        decreaseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        decreaseButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        decreaseButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        increaseButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).isActive = true
        increaseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        increaseButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        increaseButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        activityIndicatorView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 100).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupUI() {
        valueLabel.text = "0"
        valueLabel.font = .systemFont(ofSize: 15)
        decreaseButton.setImage(UIImage(systemName: "minus"), for: .normal)
        increaseButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    // MARK: - Bind
    
    func bind(reactor: CounterViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // 1. input: View -> Action -> Reactor
    private func bindAction(_ reactor: CounterViewReactor) {
        increaseButton.rx.tap
            .map { Reactor.Action.increase } // Tap event를 Action.increase로 변환
            .bind(to: reactor.action) // reactor.action에 바인딩 (전달)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // output: Reactor -> State -> View
    private func bindState(_ reactor: CounterViewReactor) {
        reactor.state
            .map { String($0.value) }
            .distinctUntilChanged() // 연속적으로 중복된 값은 무시
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
