import UIKit
import RxSwift

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// MARK: - Subject : 이벤트를 전달할 수도, 전달받을 수도 있다.

// MARK: - PublishSubject

// 서브젝트가 생성되는 시점에 아무런 이벤트가 있지 않음 그래서 옵저버가 구독하면 아무 것도 전달되지 않음
let subject = PublishSubject<String>()

subject.onNext("Hello") // 서브젝트를 구독하고 있는 옵저버가 없는 상태라 출력X

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)

subject.onNext("RxSwift") // 서브젝트를 구독 후에 이벤트 전달하는 것

let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject")

//subject.onCompleted()
subject.onError(MyError.error)

subject.onNext("AfterCompleted")

let o3 = subject.subscribe { print(">> 3", $0) } // 새로운 구독자에게도 완료/에러 이벤트를 전달
o3.disposed(by: disposeBag)


// MARK: - BehaviorSubject

/// 구독할 때 publish / behavior subject의 차이점이 나타난다.
let p = PublishSubject<Int>()
let b = BehaviorSubject<Int>(value: 0) // 초기값이 존재함

/// PublishSubject
p.subscribe {
    print("PublishSubject >> ", $0)
}
.disposed(by: disposeBag)

/// BehaviorSubject
b.subscribe {
    print("BehaviorSubject >> ", $0) // BehaviorSubject >>  next(0)
}
.disposed(by: disposeBag)

b.onNext(1)

b.subscribe {
    print("BehaviorSubject2 >> ", $0) // BehaviorSubject2 >>  next(1)
}
.disposed(by: disposeBag)

/// 즉, BehaviorSubject는 가장 최신 next event를 전달한다.

//b.onCompleted()
b.onError(MyError.error)

b.subscribe {
    print("BehaviorSubject3 >> ", $0) // BehaviorSubject3 >>  completed
}
.disposed(by: disposeBag)


// MARK: - ReplaySubject

// 버퍼에 이벤트 저장하는데 메모리 사용량에 주의!

let rs = ReplaySubject<Int>.create(bufferSize: 3) // 3개의 이벤트 저장

(1...10).forEach { rs.onNext($0) }

rs.subscribe {
    print("Observer 1>>",  $0)
}
.disposed(by: disposeBag)


rs.subscribe {
    print("Observer 2>>",  $0)
}
.disposed(by: disposeBag)

rs.onNext(11)

rs.subscribe {
    print("Observer 3>>",  $0)
}
.disposed(by: disposeBag)

rs.onCompleted()
//rs.onError(MyError.error)

rs.subscribe {
    print("Observer 4>>",  $0)
}
.disposed(by: disposeBag)

/// 종료여부에  상관없이 버퍼에 저장된 이벤트를 구독자에게 전달


// MARK: - AsyncSubject
/// completed event가 전달되기 전까지 구독자에게 이벤트를 전달하지 않고,
/// completed event가 전달될 때 바로 직전 이벤트를 전달한다.
/// 바로 전달하는 이전 subject들과 다름.

let asyncSubject = AsyncSubject<Int>()

asyncSubject
    .subscribe { print($0) }
    .disposed(by: disposeBag)

asyncSubject.onNext(1)
asyncSubject.onNext(2)
asyncSubject.onNext(3)

//asyncSubject.onCompleted() // completed event가 전달할 때 비로소 가장 최신 이벤트인 3을 전달
asyncSubject.onError(MyError.error) // error event만 전달되고 종료

