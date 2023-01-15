import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}


// 옵저버블이 네트워크 요청을 처리하고, 구독자가 ui를 업데이트함
// 에러이벤트가 전달되면 구독이 종료돼서 ui를 업데이트 하는 코드가 실행되지 않음

// MARK: - Catch
// rx는 이 경우 -> 에러 이벤트가 전달되면 catch 연산자를 통해 새로운 옵저버블/기본값/로컬캐시로 바꿔서 전달

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catch { _ in
        // catch 연산자를 통해서 기존 subject를 recovery 서브젝트로 교체함
        recovery
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)


subject.onError(MyError.error)
subject.onNext(123) // error로 구독이 종료돼서 새로운 이벤트는 전달되지 않음
subject.onNext(11)

recovery.onNext(22)
recovery.onCompleted()


// MARK: - CatchAndReturn

let mySubject = PublishSubject<Int>()

mySubject
    .catchAndReturn(-1)
    .subscribe { print($0) }
    .disposed(by: disposeBag)


mySubject.onError(MyError.error)


// MARK: - Retry

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#START => \(currentAttempts)")
    
    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    return Disposables.create {
        print("#END => \(currentAttempts)")
    }
}

// MARK: - Retry

//source
//    .retry()
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: disposeBag)

// MARK: - 재시도 횟수 설정 가능한 retry

//source
//    .retry(7)
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: disposeBag)


// MARK: - RetryWhen

let trigger = PublishSubject<Void>()

source
    .retry { _ in trigger }
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

trigger.onNext(()) // 이렇게 trigger Observable이 이벤트를 방출하기 전까지 재시도를 하지 않음
trigger.onNext(())
