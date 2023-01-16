//
//  RxCocoaCollectionViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/16.
//

import UIKit
import RxSwift
import RxCocoa

class RxCocoaCollectionViewViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var listCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        
        let colorObservable = Observable.of(MaterialBlue.allColors)
        
        // 클로저에는 인덱스, 모델데이터, 컬렉션뷰 셀
        // 재사용큐에서 셀을 꺼내고 다시 컬렉션뷰에 리턴하는 것은 알아서 처리됨
        colorObservable.bind(to: listCollectionView.rx.items(
            cellIdentifier: "colorCell",
            cellType: ColorCollectionViewCell.self)) { index, color, cell in
                cell.backgroundColor = color
                cell.hexLabel.text = color.rgbHexString
            }
            .disposed(by: bag)
        
        listCollectionView.rx.modelSelected(UIColor.self)
            .subscribe { color in
                print(color.rgbHexString)
            }
            .disposed(by: bag)
        
        listCollectionView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                self?.listCollectionView.deselectItem(at: indexPath, animated: true)
            }
            .disposed(by: bag)
        
        listCollectionView.rx.setDelegate(self)
            .disposed(by: bag)
    }
}


extension RxCocoaCollectionViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
        return CGSize(width: value, height: value)
    }
}
