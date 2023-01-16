//
//  DriverViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/16.
//

import UIKit

import RxSwift
import RxCocoa

enum ValidationError: Error {
    case notANumber
}

class DriverViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        let result = inputField.rx.text
            .flatMapLatest {
                self.validateText($0)
                    .observe(on: MainScheduler.instance) // Main Scheduler를 직접 지정해서 잠재적인 오류 발생 제어
                .catchAndReturn(false)
            }
            .share() // 모든 구독자가 하나의 시퀀스를 구독
        
        /// 3번 bind 구독처리가 되어 시퀀스가 3번 발생
        result
            .map { $0 ? "OK" : "Error" }
            .bind(to: resultLabel.rx.text)
            .disposed(by: bag)
        
        result
            .map { $0 ? UIColor.blue : UIColor.red }
            .bind(to: resultLabel.rx.backgroundColor)
            .disposed(by: bag)
        
        result
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
    func validateText(_ value: String?) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            print("== \(value ?? "") Sequence Start ==")
            
            // 작성된 위치랑 상관없이 함수 종료 직전에 실행되는 구문
            defer {
                print("== \(value ?? "") Sequence End ==")
            }
            
            guard let str = value, let _ = Double(str) else {
                observer.onError(ValidationError.notANumber)
                return Disposables.create()
            }
            
            observer.onNext(true)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
