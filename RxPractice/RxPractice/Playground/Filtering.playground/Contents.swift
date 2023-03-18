import UIKit

import RxSwift

let bag = DisposeBag()

// MARK: - IgnoreElements next 이벤트를 필터링하는 연산자

let friends = ["소깡", "디온", "방구"]

Observable.from(friends)
    .ignoreElements()
    .subscribe { print($0) }
    .disposed(by: bag)
//completed

// MARK: - elementAt 특정 인덱스에 위치한 요소를 제한적으로 방출하는 연산자

Observable.from(friends)
    .element(at: 2)
    .subscribe { print($0) }
    .disposed(by: bag)
//next(방구)

// MARK: - filter 특정 조건에 맞는 항목을 필터링

let num = [1,2,3,4,5,6,7,8]
Observable.from(num)
    .filter { $0.isMultiple(of: 2) }
    .subscribe { print($0)}
    .disposed(by: bag)
//next(2)
//next(4)
//next(6)
//next(8)


// MARK: - skip 지정한 수만큼 next 이벤트 무시하는 연산자

// index 아님 count임
Observable.from(num)
    .skip(3) // 이 숫자만큼 무시 -> 3개 무시
    .subscribe { print($0)}
    .disposed(by: bag)
//next(4)
//next(5)
//next(6)
//next(7)
//next(8)


// MARK: - skip(until:) 트리거 옵저버블이 이벤트를 방출하기 전까지 next 이벤트 무시

// Observable을 파라미터로 받고, 파라미터로 받은 이 옵저버블 즉, 트리거 옵저버블이 이벤트 방출해야 그때서야 전달
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.skip(until: trigger)

subject.skip(until: trigger)
    .subscribe { print($0)}
    .disposed(by: bag)

subject.onNext(1) // trigger가 이벤트를 방출하지 않아서 전달x
trigger.onNext(100)
subject.onNext(20) // 얘만 방출함
//next(20)


// MARK: - skip(while:) 조건에 따라 이벤트 방출을 결정하는 연산자

// filter와 다르게 한 번이라도 false를 방출하면 그 후부터 쭉 다 방출
let nums = [1,2,3,4,5,6,7,8]
// 홀수는 true라 skip이니까 1을 skip, 2부터는 false라 그 후부터 다 방출
Observable.from(nums)
    .skip { !$0.isMultiple(of: 2)}
    .subscribe { print($0)}
    .disposed(by: bag)
//next(2)
//next(3)
//next(4)
//next(5)
//next(6)
//next(7)
//next(8)


// MARK: - skip(duration:schedular:) 지정한 시간동안 이벤트 방출을 무시하는 연산자

let number = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

// 시간 처리 시 오차가 발생함!!! -> 1초마다 방출하는 게 아니다.
// 그래서 원래는 3초를 무시해야 하니까, 0, 1, 2 무시하고 3부터 방출해야 할 것 같지만 2부터 방출하는 것.
// 항상 오차가 있다는 거를 알고 사용하자!
//number
//    .take(10)
//    .skip(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe { print($0)}
//    .disposed(by: bag)
//next(2)
//next(3)
//next(4)
//next(5)
//next(6)
//next(7)
//next(8)
//next(9)


// MARK: - take 처음 n개의 이벤트만 방출하는 연산자

let numbers = [1,2,3,4,5]
Observable.from(numbers)
    .take(5)
    .subscribe { print($0)}
    .disposed(by: bag)


// MARK: - take(while:) 조건을 충족하는 동안 이벤트를 방출하는 연산자

// while : true면 방출, false면 X
// behavior : 마지막에 확인한 값을 방출할 건지 말지
// - .inclusive면 조건에 충족하지 않아도 방출 (보통 잘 사용하지 않음)
// - 기본값은 .exclusive

let my = [11,12,13,14,15]
Observable.from(my)
    .take(while: { !$0.isMultiple(of: 2) }) // 홀수만 방출 -> 12나오는 순간 false라 전달X
    .subscribe { print($0) }
    .disposed(by: bag)
//next(11)

Observable.from(my)
    .take(while: { !$0.isMultiple(of: 2) }, behavior: .inclusive)
    .subscribe { print($0) }
    .disposed(by: bag)
//next(11)
//next(12) -> 마지막에 확인한 값이 조건을 충족하지 않지만 .inclusive라 방출


// MARK: - take(until:) 트리거 옵저버블이 next 이벤트를 방출하기 전까지 이벤트를 방출

let mySubject = PublishSubject<Int>()
let myTrigger = PublishSubject<Int>()

/**
 1. 옵저버블을 파라미터로 받고, 이 옵저버블이 next event를 전달하기 전까지 원본 옵저버블에서 next event를 전달
 */
mySubject.take(until: myTrigger)
    .subscribe { print($0) }
    .disposed(by: bag)

mySubject.onNext(100)
//next(100)
mySubject.onNext(200)
//next(100)
//next(200)
myTrigger.onNext(0)
//next(100)
//next(200)
//completed
mySubject.onNext(300)

//300은 더이상 방출되지 않음.
//-> myTrigger 옵저버블이 이벤트를 전달했기 때문에 원본인 mySubject가 전달하는 건 더이상X

/**
 2. 클로저에서 false를 전달하면 이벤트 방출을 중단하고 옵저버블 종료
 */
mySubject.take(until: { $0 > 5})
    .subscribe {print($0)}
    .disposed(by: bag)

mySubject.onNext(1)
mySubject.onNext(2)
//next(1)
//next(2)
mySubject.onNext(10) // -> 5보다 큰 순간 false 중단.


// MARK: - takeLast 원본 옵저버블의 마지막 n개 이벤트만 방출하는 takeLast 연산자

let subject2 = PublishSubject<Int>()

subject2
    .takeLast(2) // -> 마지막 2개의 이벤트를 버퍼에 저장해둠
    .subscribe { print($0) }
    .disposed(by: bag)

(1...10).forEach { subject2.onNext($0) } // -> 9, 10을 저장해두고 있는 상태

subject2.onNext(11) // -> 10과 11로 버퍼에 업데이트
subject2.onCompleted() // -> 방출
//next(10)
//next(11)

enum MyError: Error {
    case error
}
subject2.onError(MyError.error) // 만약 completed 방출 전에 error event 방출시키면 error이벤트만 전달
//error(error)


// MARK: - take(for:scheduler:) 지정한 시간동안 이벤트를 방출하는 take(for:scheduler:)

let number2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

//number2
//    .take(for: .seconds(5), scheduler: MainScheduler.instance)
//    .subscribe { print($0) }
//    .disposed(by: bag)
//next(0)
//next(1) -> 시간 오차가 있기 때문에 0, 1까지만 방출하고 끝남 (오차가 있다는 것을 알고 사용하자.)
//completed


// MARK: - single 하나의 요소가 방출되는 것을 보장하는 연산자

let number3 = [1,2,3,4,5,6,7,8,9,10]

Observable.just(1)
    .single()
    .subscribe { print($0)}
    .disposed(by: bag)
//next(1)

// single 연산자는 단 하나의 요소만 방출되어야 종료됨
Observable.from(number3)
    .single()
    .subscribe { print($0)}
    .disposed(by: bag)
//error(Sequence contains more than one element.)

// 3인 경우만 방출
Observable.from(number3)
    .single { $0 == 3 }
    .subscribe { print($0)}
    .disposed(by: bag)
//next(3)
//completed

let sub = PublishSubject<Int>()

sub.single()
    .subscribe { print($0)}
    .disposed(by: bag)

sub.onNext(9) // 하나의 요소가 전달됐다고 해서 바로 completed event를 전달하지 않음
// -> 또 다른 요소를 방출할 수 있기 때문에


// MARK: - distinctUntilChanged 동일한 요소가 연속적으로 방출되는 것을 막아주는 연산자

struct People {
    let name: String
    let age: Int
}

let numberArr = [1111,1111,300,20,20,30,1111,40,40,80,80,80]
let tuples = [(1,"하나"),(1,"일"),(1,"one")]
let people = [
    People(name: "루이", age: 13),
    People(name: "후이", age: 13),
    People(name: "부리", age: 23)
]

/**
 기본버전 - distinctUntilChanged()
 방출하는 이벤트가 이전 이벤트랑 비교해서 같으면 방출하지 않음
 */
Observable.from(numberArr)
    .distinctUntilChanged()
    .subscribe { print($0) }
    .disposed(by: bag)

//동일한 이벤트가 연속적으로 방출되면 하나만 방출함
//동일한 이벤트가 연속적으로 방출된 게 아니면 그냥 방출함. -> 1111
//next(1111)
//next(300)
//next(20)
//next(30)
//next(1111)
//next(40)
//next(80)


/**
 - .distinctUntilChanged(comparer:)
 직접 비교하고 싶으면 comparer라는 클로저를 통해서 가능
 */
Observable.from(numberArr)
    .distinctUntilChanged { !$0.isMultiple(of: 2) && !$1.isMultiple(of: 2) } // 둘 다 홀수이면 방출
    .subscribe { print($0) }
    .disposed(by: bag)

// 즉, 연속된 수가 홀수면 같다고 판단하는 것임
// 그래서 처음에 있는 1111, 1111만 연속으로 홀수라서 한 번만 방출
//next(1111)
//next(300)
//next(20)
//next(20)
//next(30)
//next(1111)
//next(40)
//next(40)
//next(80)
//next(80)
//next(80)


/**
- .distinctUntilChanged(keySelector:)
 튜플처럼 여러값을 갖고 있는 compound value인 경우에 사용하고,
 비교할 값을 넣어줄 때는 Equatable을 따라야 한다.
 */
Observable.from(tuples)
    .distinctUntilChanged { $0.0 }
    .subscribe { print($0) }
    .disposed(by: bag)
//next((1, "하나")) -> 튜플의 첫 번째 값은 모두 같아서 1개만 전달


/**
 - .distinctUntilChanged(at: KeyPath<옵저버블타입, Equatable>)
 파라미터로 비교할 속성을 넣어줌
 */
Observable.from(people)
    .distinctUntilChanged(at: \.age)
    .subscribe { print($0) }
    .disposed(by: bag)
//next(People(name: "루이", age: 13)) -> 후이와 루이는 나이가 같아서 후이는 전달X
//next(People(name: "부리", age: 23))




// MARK: - Debounce 지정된 시간 동안 이벤트가 발생하지 않으면 가장 마지막 이벤트를 구독자에게 전달

/**
 debounce :
 - dueTime : 시간. next event를 방출할 지 결정하는 조건,
 옵저버가 next event를 방출한 다음 또 다른 next event를 지정된 시간 내에 방출하지 않는다면 해당 시점의 가장 마지막 이벤트를 구독자에게 전달
 반대로, 지정된 시간 내에 방출한다면 타이머를 초기화함. 그리고 지정된 시간 내에 대기함.
 
 - scheduler : 타이머를 실행할 스케줄러,
 
 */

let buttonTap = Observable<String>.create { observer in
    DispatchQueue.global().async {
        
        // 0.3초 주기로 10번 방출
        for i in 1...10 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // 1초동안 스레드 중지
        Thread.sleep(forTimeInterval: 1)
        
        // 0.5초 주기로 10번 방출
        for i in 11...20 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }
        observer.onCompleted()
    }
    return Disposables.create { }
}
//
//buttonTap
//    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
//    .subscribe { print($0) }
//    .disposed(by: bag)

// 0.3초 주기로 1~10을 방출하는데
// debounce도 1초가 타이머인데 그때마다 next event가 방출되니까 타이머가 갱신되는 것임
// 그리고 1초를 쉬니까 그때 이제 가장 마지막 방출된 10이 전달된 것
//next(Tap 10)
//next(Tap 20) -> 20도 마찬가지
//completed




// MARK: - Throttle

/**
 - throttle : next event를 지정된 주기마다 구독자에게 전달 (반복되는 탭이벤트)
 */

// 1초마다 정수를 방출하는 옵저버블에서 2.5초 주기를 가진 throttle 연산자
// debug는 이벤트 발생시간을 체크하기 위함

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .take(10)
    .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

// true를 전달하면 주기를 정확히 지킴 2.5초마다 가장 최근에 방출한 값을 구독자에게 전달

//2023-03-18 14:06:52.995: Filtering.playground:403 (__lldb_expr_174) -> Event next(0)
//next(0)
//2023-03-18 14:06:53.995: Filtering.playground:403 (__lldb_expr_174) -> Event next(1)
//2023-03-18 14:06:54.994: Filtering.playground:403 (__lldb_expr_174) -> Event next(2)
//next(2)
//2023-03-18 14:06:55.994: Filtering.playground:403 (__lldb_expr_174) -> Event next(3)
//2023-03-18 14:06:56.995: Filtering.playground:403 (__lldb_expr_174) -> Event next(4)
//2023-03-18 14:06:57.995: Filtering.playground:403 (__lldb_expr_174) -> Event next(5)
//next(5)
//2023-03-18 14:06:58.994: Filtering.playground:403 (__lldb_expr_174) -> Event next(6)
//2023-03-18 14:06:59.994: Filtering.playground:403 (__lldb_expr_174) -> Event next(7)
//next(7)
//2023-03-18 14:07:00.993: Filtering.playground:403 (__lldb_expr_174) -> Event next(8)
//2023-03-18 14:07:01.993: Filtering.playground:403 (__lldb_expr_174) -> Event next(9)
//2023-03-18 14:07:01.993: Filtering.playground:403 (__lldb_expr_174) -> isDisposed
//next(9)


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .take(10)
    .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

// latest가 false면 지정된 주기가 지나고 그 이후에 방출되는 next event가 전달된다.

//2023-03-18 14:09:08.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(0)
//next(0)
//2023-03-18 14:09:09.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(1)
//2023-03-18 14:09:10.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(2)
//2023-03-18 14:09:11.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(3)
//next(3)
//2023-03-18 14:09:12.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(4)
//2023-03-18 14:09:13.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(5)
//2023-03-18 14:09:14.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(6)
//next(6)
//2023-03-18 14:09:15.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(7)
//2023-03-18 14:09:16.343: Filtering.playground:430 (__lldb_expr_178) -> Event next(8)
//2023-03-18 14:09:17.344: Filtering.playground:430 (__lldb_expr_178) -> Event next(9)
//next(9)
//completed

// true는 지정된 주기를 엄격하게 지키지만, false는 주기를 초과할 수 있다.
