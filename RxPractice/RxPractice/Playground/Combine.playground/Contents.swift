import UIKit

import RxSwift

let bag = DisposeBag()

// MARK: - startWith : 옵저버블 시퀀스 앞에 새로운 요소를 추가

let num = [1,2,3,4,5]

// 기본값이나 시작값 지정시 활용
Observable.from(num)
    .startWith(9999) // 2개 이상 연달아 사용 가능
    .startWith(1111, 2222)
    .startWith(3333)
    .subscribe { print($0) }
    .disposed(by: bag)

// Last In First Out -> 가장 마지막에 추가한 값이 가장 처음으로 방출된다.
//그래서 3333이 가장 나중에 추가했지만 가장 먼저 방출
//1111, 2222는 나란히 추가해서 순서를 지켰고,
//9999는 가장 나중에 방출
//next(3333)
//next(1111)
//next(2222)
//next(9999)
//next(1)
//next(2)
//next(3)
//next(4)
//next(5)


// MARK: - concat : 두 개의 옵저버블을 연결

let fruits = Observable.from(["🍑", "🍉", "🍇"])
let animals = Observable.from(["🐝", "🦁", "🐷"])

// 단순히 하나로 연결함
Observable.concat([fruits, animals])
    .subscribe { print($0) }
    .disposed(by: bag)

// 과일 방출 후 동물 방출 -> 연결된 요소가 모두 방출 후 completed
//next(🍑)
//next(🍉)
//next(🍇)
//next(🐝)
//next(🦁)
//next(🐷)
//completed

// 대상 옵저버블이 completed 된 경우, animals를 전달
fruits.concat(animals)
    .subscribe { print($0) }
    .disposed(by: bag)
//next(🍑)
//next(🍉)
//next(🍇)
//next(🐝)
//next(🦁)
//next(🐷)
//completed

animals.concat(fruits)
    .subscribe { print($0) }
    .disposed(by: bag)
//next(🐝)
//next(🦁)
//next(🐷)
//next(🍑)
//next(🍉)
//next(🍇)
//completed


// MARK: - merge : 여러 옵저버블이 방출하는 이벤트를 하나의 옵저버블에서 방출하도록 병합

/*
 concat과 다름.
 동작방식이 다름!!
 1개의 옵저버블이 -> concat
 
 merge는 2개 이상의 옵저버블이 방출하는 이벤트 합치기
 
 */

enum MyError: Error {
    case error
}

let odd = BehaviorSubject(value: 1)
let even = BehaviorSubject(value: 2)
let negative = BehaviorSubject(value: -1)

let source = Observable.of(odd, even)

// 2개 이상의 옵저버블을 하나로 합쳐서 각 옵저버블의 이벤트를 순서대로 구독자에게 전달
source
    .merge()
    .subscribe { print($0) }
    .disposed(by: bag)

//next(1)
//next(2)

odd.onNext(3)
even.onNext(4)
even.onNext(6)
odd.onNext(5)

//next(1)
//next(2)
//next(3)
//next(4)
//next(6)
//next(5)

odd.onCompleted() // 구독 종료 -> 이벤트 전달 X
//odd.onError(MyError.error) // 근데 하나라도 error 이벤트 전달하면 더 이상 다른 이벤트 전달X
even.onNext(2) // odd.completed여도 여전히 이벤트를 받을 수 있음, 근데 odd.onError면 X
//next(1)
//next(2)
//next(3)
//next(4)
//next(6)
//next(5)
//next(2) -> 이게 error 면 전달이 안된다 이거야!



/// maxConcurrent 설정

let odd1 = BehaviorSubject(value: 1)
let even1 = BehaviorSubject(value: 2)
let negative1 = BehaviorSubject(value: -1)
let source1 = Observable.of(odd1, even1, negative1)

source1
    .merge(maxConcurrent: 2) // 병합 가능한 옵저버블의 수가 2개로 제한
    .subscribe { print($0) }
    .disposed(by: bag)

odd1.onNext(300)
even1.onNext(100)
even1.onNext(1000)
negative1.onNext(-2) // 병합 대상이 최대 2개라 negative는 제외됨

/* 그러나 앞 2 옵저버블 중 1개라도 구독 종료되면, 큐에 대기 중이던 negative 옵저버블의 이벤트가 바로 전달됨
next(300)
next(100)
next(1000)
*/

even1.onCompleted()
/* even1 옵저버블이 구독 종료돼서 가장 최근 negative1 옵저버블의 이벤트가 전달
 next(300)
 next(100)
 next(1000)
 next(-2)
*/



// MARK: - switchLatest : 가장 최근에 방출된 옵저버블을 구독하고, 이 옵저버블이 전달하는 이벤트를 구독자에게 전달

let a = PublishSubject<String>()
let b = PublishSubject<String>()

// 문자열을 방출하는 옵저버블 <--- 을 방출하는 서브젝트임
let source2 = PublishSubject<Observable<String>>()

// 옵저버블을 방출하는 옵저버블에서 사용
source2
    .switchLatest()
    .subscribe { print($0) }
    .disposed(by: bag)

source2.onNext(a) // source2 서브젝트로 a를 전달 -> 옵저버블이 방출
//next(RxSwift.PublishSubject<Swift.String>)

//최신(최근) 이벤트인 옵저버블인 a에서 전달하는 이벤트를 구독자에게 전달한다.
a.onNext(">> a가 source2에게 전달한 이벤트입니다~")
//next(>> a가 source2에게 전달한 이벤트입니다~)

b.onNext(".... b는 최신 옵저버블이 아니라 이벤트 전달X")



source2.onNext(b) // b 옵저버블을 최신으로 만드려면 이렇게 source2로 b를 전달해야 함

a.onNext(">> a")
b.onNext(">> b")
//next(>> b)

a.onCompleted() // 전달X
b.onCompleted() // 전달X
source2.onCompleted() // 전달O

/* 반면 error event는 다름
 a.onError(MyError.error) // 전달X
 b.onError(MyError.error) // 전달O -> 최신 이벤트라서 즉시 전달됨
 error(error)
*/



// MARK: - withLatestFrom : triggerObservable.withLatestFrom(dataObservable)
/* 트리거 옵저버블이 Next 이벤트를 방출하면
 데이터 옵저버블이 가장 최근에 방출한 next 이벤트를 구독자에게 전달
 
 - 트리거 : 연산자를 호출하는 옵저버블
 - 데이터 : 파라미터로 전달하는 옵저버블
 
 회원가입 탭하면 텍스트 필드 내용 가져오는 기능 구현에 사용
 
 signInButton.rx.tap
     .withLatestFrom(textField.rx.text)
 
 signButton~ : trigger
 textFeild~ : dataObservable
 
 
 -> 즉, 트리거 옵저버블의 이벤트는
 데이터 옵저버블에서 이벤트가 방출되기 전까지는
 가장 최신 이벤트를 제외하고 무시되는 게 특징
 https://velog.io/@iammiori/RxSwift-17.-withLatestFrom-적용해보기
 */



let trigger1 = PublishSubject<Void>()
let data1 = PublishSubject<String>()


trigger1
    .withLatestFrom(data1)
    .subscribe { print($0) }
    .disposed(by: bag)


data1.onNext("안녕")
// 아직 trigger 서브젝트가 next 이벤트를 전달하지 않아서 구독자에게 전달X

trigger1.onNext(()) // next(안녕)
trigger1.onNext(()) // next(안녕)
trigger1.onNext(())

//next(안녕)
//next(안녕)
//next(안녕)
// 반복적으로 최신 방출한 이벤트를 전달한다. sample과 다른 점임

data1.onCompleted()
trigger1.onNext(())
//next(안녕) -> 마지막으로 전달된 이벤트 전달


/*
 에러의 경우, 바로 에러 전달
 data1.onError(MyError.error)
 //error(error)
 trigger1.onNext(())
 */

trigger1.onCompleted()
//completed -> data1 서브젝트에 전달하는 것과 다르게 바로 구독 종료, error도 마찬가지. 즉시 전달되고 종료



// MARK: - Sample : dataObservable.withLatestFrom(triggerObservable)
/* 트리거 옵저버블이 next 이벤트를 전달할 때마다
 데이터 옵저버블이 Next 이벤트를 방출하지만,
 동일한 next 이벤트를 반복해서 방출하지 않는 연산자
 */

// withLatestFrom과 반대

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

data
    .sample(trigger)
    .subscribe { print($0) }
    .disposed(by: bag)

trigger.onNext(())

data.onNext("HELLO")
trigger.onNext(()) // trigger 서브젝트로 next 이벤트를 전달한 경우에만 구독자에게 전달된다.
//next(HELLO)
trigger.onNext(())
trigger.onNext(()) // 이렇게 반복하면 동일한 이벤트는 중복해서 보내지 않는다.

data.onNext("HI")
trigger.onNext(())
//next(HI)

data.onCompleted()
trigger.onNext(())
//completed

/* error인 경우?
data.onError(MyError.error)
 ->> trigger 옵저버블이 전달하지 않아도 즉시 구독자에게 전달
error(error)
 */

