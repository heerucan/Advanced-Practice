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

// MARK: - just 연산자

Observable.just([1, 2, 3])
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)

// MARK: - of 연산자 : next event가 다 전달

Observable.of("apple", "banana")
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)

Observable.of([1, 2, 3], [4, 5, 6])
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)

// MARK: - from : 배열에 저장된 요소를 하나씩 방출하려면

Observable.from([1, 2, 3])
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)

/// 하나의 요소를 방출 = just
/// 두 개 이상의 요소를 방출 = of
/// just랑 of는 요소를 묶어서 하나씩 방출하니까 배열 내 원소를 하나씩 방출하려면 from


// MARK: - Create

Observable<String>.create { (observer) -> Disposable in
    guard let url = URL(string: "https://www.apple.com") else {
        observer.onError(MyError.error) // url이 없으면 error 이벤트 호출
        return Disposables.create()
    }
    
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error) // 문자열을 저장하지 못하면 error 이벤트 호출
        return Disposables.create()
    }
    
    // 문자열을 정상적으로 저장하면 html을 가져옴
    observer.onNext(html)
    observer.onCompleted()
    
    observer.onNext("After completed") // complete 이후라 전달되지 않음
    
    return Disposables.create() // Disposables를 생성해서 리턴
}
.subscribe { print($0) }
.disposed(by: disposeBag)
