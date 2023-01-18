//
//  NSObjectViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class NSObjectRxViewController: UIViewController {
    
//    let bag = DisposeBag()
    // NSObject 클래스를 확장해서 disposeBag 속성을 추가한다.
    
    let button = UIButton(type: .system)
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just("Hello")
            .subscribe { print($0) }
            .disposed(by: rx.disposeBag)
        
        button.rx.tap
            .map { "Hello" }
            .bind(to: label.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

// 프로토콜을 통해 DisposeBag을 추가
// 클래스 프로토콜로 선언되어서 구조체에서는 선언이 불가능
class MyClass: HasDisposeBag {
    
    func doSomething() {
        Observable.just("Hello")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
}

