//
//  RxCocoaTableViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/16.
//

import UIKit
import RxSwift
import RxCocoa


class RxCocoaTableViewViewController: UIViewController, UIScrollViewDelegate {
    
    let bag = DisposeBag()

    @IBOutlet weak var listTableView: UITableView!
    
    let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.currency
        f.locale = Locale(identifier: "Ko_kr")
        
        return f
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        
        let nameObservable = Observable.of(appleProducts.map { $0.name })
        let productObservable = Observable.of(appleProducts)
        
        
        // MARK: - 1번 방식
        nameObservable.bind(to: listTableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
            cell.textLabel?.text = element
            return cell
        }
        .disposed(by: bag)

        
        // MARK: - 2번 방식
        // 기본셀을 받아서 구현
        nameObservable.bind(to: listTableView.rx.items(cellIdentifier: "standardCell")) { row, element, cell in
            cell.textLabel?.text = element
        }
        .disposed(by: bag)
        
        
        // MARK: - 3번 방식
        /// 타입캐스팅이 되어 전달
        productObservable.bind(to: listTableView.rx.items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) { row, element, cell in
            cell.categoryLabel.text = element.category
            cell.productNameLabel.text = element.name
            cell.summaryLabel.text = element.summary
            cell.priceLabel.text = self.priceFormatter.string(for: element.price)
        }
        .disposed(by: bag)
        
        // MARK: - 모델 출력
        listTableView.rx.modelSelected(Product.self)
            .subscribe(onNext: { product in
                print(product.name)
            })
            .disposed(by: bag)

        // MARK: - indexPath 출력
        listTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, indexPath in
                vc.listTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: bag)
        
        // MARK: - 위 두 작업을 하나로 합칠 것임 ControlEvent를 return함
        /// zip 연산자로 병합할 수 있음
        Observable.zip(listTableView.rx.modelSelected(Product.self), listTableView.rx.itemSelected)
            .bind { [weak self] (product, indexPath) in
                self?.listTableView.deselectRow(at: indexPath, animated: true)
                print(product.name)
            }
            .disposed(by: bag)
        
        
        // MARK: - Delegate 지정방식
        listTableView.rx.setDelegate(self)
            .disposed(by: bag)
        /// setDataSource는 거의 사용하지 않음
    }
}
