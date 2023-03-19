import UIKit

import RxSwift

// MARK: - Amb 연산자 - 여러 옵저버블 중에서 가장 먼저 이벤트를 방출하는 옵저버블을 선택하는 것

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()
let c = PublishSubject<String>()

// 소스 옵저버블이 2개로 제한될 경우
a.amb(b)
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("A") // a가 먼저 이벤트를 방출해서 b는 무시됐음
b.onNext("B")
//next(A)

b.onCompleted() // b는 무시
a.onCompleted() // a가 전달하는 이벤트는 구독자에게 바로 전달
//completed

// 3개 이상의 옵저버블을 전달할 경우 사용 - 모든 소스 옵저버블을 배열 형태로 전달
Observable.amb([a, b, c])
    .subscribe { print($0) }
    .disposed(by: bag)
