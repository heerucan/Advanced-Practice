import UIKit
import RxSwift

let disposeBag = DisposeBag()

Observable.just("Hello, RxSwift")
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// MARK: - 옵저버블을 생성하는 연산자
// #1 create
Observable<Int>.create { observer -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    observer.onCompleted() // 옵저버블이 종료
    return Disposables.create() // 메모리정리에 필요한 객체 : Disposable
}

// #2 from 배열 요소를 순서대로 방출
Observable.from([0, 1])
    
/// 이 상태에서는 옵저버블을 생성만 한 상태임. 방출되거나 이벤트가 전달되진 않음.
/// 옵저버가 옵저버블을 구독하는 시점에야만 이벤트가 전달됨
