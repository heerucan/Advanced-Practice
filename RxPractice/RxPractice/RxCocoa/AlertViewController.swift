//
//  AlertViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/16.
//

import UIKit
import RxSwift
import RxCocoa

class RxCocoaAlertViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var oneActionAlertButton: UIButton!
    
    @IBOutlet weak var twoActionsAlertButton: UIButton!
    
    @IBOutlet weak var actionSheetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - OK 버튼 탭하면 Hex값 나옴
        oneActionAlertButton.rx.tap
            .flatMap { [unowned self] in
                self.info(
                    title: "Current Color",
                    message: self.colorView.backgroundColor?.rgbHexString)
            }
            .subscribe { [unowned self] actionType in
                switch actionType {
                case .ok:
                    print(self.colorView.backgroundColor?.rgbHexString ?? "")
                default:
                    break
                }
            }
            .disposed(by: bag)
        
        // MARK: - OK 버튼 탭하면 background 색상이 검정으로 변경
        twoActionsAlertButton.rx.tap
            .flatMap { [unowned self] in
                self.alert(title: "Reset Color", message: "Reset to black Color?")
            }
            .subscribe { [unowned self] actionType in
                switch actionType {
                case .ok:
                    self.colorView.backgroundColor = UIColor.black
                default:
                    break
                }
            }
            .disposed(by: bag)
        
        // MARK: - ActionSheet 컬러 선택하면 색상 변경
        actionSheetButton.rx.tap
            .flatMap { [unowned self] in
                self.colorActionSheet(colors: MaterialBlue.allColors, title: "Change Color", message: "Choose one")
            }
            .subscribe { [unowned self] color in
                self.colorView.backgroundColor = color
            }
            .disposed(by: bag)
    }
}

enum ActionType {
    case ok
    case cancel
}

extension UIViewController {
    func info(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                observer.onNext(.ok)
                observer.onCompleted()
            }
            
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
    
    func alert(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                observer.onNext(.ok)
                observer.onCompleted()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
                observer.onNext(.cancel)
                observer.onCompleted()
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true, completion: nil)
            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
    
    func colorActionSheet(colors: [UIColor], title: String, message: String? = nil) -> Observable<UIColor> {
        
        return Observable.create { [weak self] observer in
            
            let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for color in colors {
                let colorAction = UIAlertAction(title: color.rgbHexString, style: .default) { _ in
                    observer.onNext(color)
                    observer.onCompleted()
                }
                
                actionSheet.addAction(colorAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onCompleted()
            }
            
            actionSheet.addAction(cancelAction)
            self?.present(actionSheet, animated: true)
            
            return Disposables.create {
                actionSheet.dismiss(animated: true, completion: nil)
            }
        }
    }
}
