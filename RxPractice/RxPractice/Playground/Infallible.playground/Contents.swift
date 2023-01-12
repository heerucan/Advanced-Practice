import UIKit
import RxSwift

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// MARK: - RxSwift6에서 추가된 새로운 형태의 옵저버블

let observable = Observable<String>.create { observer in
    observer.onNext("Hello")
    observer.onNext("Observable")
    observer.onCompleted()
    return Disposables.create()
}

/// next, completed만 방출하는 새로운 옵저버블
/// Driver와 Signal도 약간 비슷
let infallible = Infallible<String>.create { observer in
    observer(.next("Hello"))
    observer(.completed)
    return Disposables.create()
}
