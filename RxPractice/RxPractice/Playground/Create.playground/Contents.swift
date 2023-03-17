import UIKit

import RxSwift

let disposeBag = DisposeBag()
let element = "🎀"

// MARK: - just, of, from 옵저버블 생성에 사용한느 가장 단순하고 기초적인 세가지 연산자

// just는 파라미터로 전달한 걸 그대로 전달한다.
// 🎀
Observable.just("🎀")
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)

// [1, 2, 3]
Observable.just([1, 2, 3])
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)


// of는 두 개 이상을 전달할 때 가능, just로는 불가능
// 문자열 2개가 각각 전달이 된다.
//next(a)
//next(b)
Observable.of("a", "b")
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)


//next([1, 2])
//next([3, 4])
Observable.of([1,2], [3,4])
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)

// 배열에 저장된 요소를 하나씩 방출하고 싶다면 from을 사용한다.
//next(1)
//next(2)
//next(3)
//next(4)
Observable.from([1,2,3,4])
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)


// MARK: - range, generate정수를 지정된 수만큼 방출하는 옵저버블

// 1씩 증가하는 연산자임
//next(1)
//next(2)
//next(3)
//next(4)
//next(5)
Observable.range(start: 1, count: 5) // start에 정수를 넣어야 함
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 시작값(가장 먼저 방출되는 값)
// true를 리턴해야 요소 방출, false를 방출 시 completed
// iterate 요소는 값을 변경하는 것

// generate는 파라미터가 정수로 제한되지 않는다.
//next(10)
//next(8)
//next(6)
//next(4)
//next(2)
Observable.generate(initialState: 10, condition: { $0 > 0 }, iterate: { $0-2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

//next(📕)
//next(📕📘)
//next(📕📘📕)
//next(📕📘📕📘)
//next(📕📘📕📘📕)
//next(📕📘📕📘📕📘)
Observable
    .generate(initialState: "📕",
              condition: { $0.count<7 },
              iterate: { $0.count.isMultiple(of: 2) ? $0 + "📕" : $0 + "📘" })
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// MARK: - RepeatElement 동일한 요소를 반복적으로 방출하는 옵저버블

// 해당 요소를 반복적으로 반환 - 무한정 반복해줌
// 그래서 방출되는 요소를 제한해줘야 함 - take 연산자로
Observable.repeatElement("루")
    .take(7)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

//next(루)
//next(루)
//next(루)
//next(루)
//next(루)
//next(루)
//next(루)


// MARK: - deferred 특정 조건에 따라 옵저버블을 생성하는 방법

var flag = true

let factory = Observable.deferred {
    flag.toggle()
    
    if flag {
        return Observable.from(["루희", "사랑", "하트", "해피"])
    } else {
        return Observable.from(["힘듦", "그지", "아픔", "우울"])
    }
}

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// 초반에 true를 toggle로 뒤집었기 때문에 false값으로 바껴서 from 연산자의 요소가 방출됨
//next(힘듦)
//next(그지)
//next(아픔)
//next(우울)

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// 다시 factory 옵저버블을 구독해서 false -> true로 바껴서 true값의 요소가 방출
//next(루희)
//next(사랑)
//next(하트)
//next(해피)


// MARK: - create 옵저버블을 직접 구현

// 앞 연산자들까지는 파라미터로 전달된 요소를 방출하는 옵저버블을 생성한다.
// 모든 요소를 방출하고 끝낸다. 그리고 동작을 바꿀 수 없다.
// 직접 구현하고 싶다면, create를 써야 한다.

enum MyError: Error {
    case error
}

// 요소를 방출할 때는 onNext를 사용하고, 파라미터로 방출할 요소를 전달하자.
// 옵저버블을 종료하기 위해서는 onError, onCompleted를 반드시 호출해야 한다.
// onNext를 호출하려면 두 메소드가 호출되기 전에 호출해야 한다.

//옵저버를 파라미터로 받아서 Disposable을 반환한다.
//잘못된 URL을 사용하면 오류가 발생한 거니까 error event를 반환해야 함
//observer에서 onError를 방출하자! + Disposable 반환

//문자열을 저장할 수 없다면 에러이벤트 전달

//문자열을 잘 저장했다면 문자열을 방출하자! onNext로!

//error가 발생하면 error event 방출

Observable<String>.create { (observer) -> Disposable in
    guard let url = URL(string: "https://www.apple.com") else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    
    observer.onNext(html)
    observer.onCompleted()
    return Disposables.create()
}
.subscribe { print($0) }
.disposed(by: disposeBag)


// MARK: - empty, error 요소를 방출하지 않는 특별한 연산자

// next event를 방출하지 않는다!

// empty 연산자는 파라미터가 없다
// 옵저버가 아무런 동작없이 종료해야 할 때 쓴다
// completed
Observable<Void>.empty()
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// error - 에러를 처리할 때 활용
// error(error)
Observable<Void>.error(MyError.error)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
