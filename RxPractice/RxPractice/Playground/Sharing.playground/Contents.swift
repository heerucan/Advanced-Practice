import UIKit

import RxSwift

let bag = DisposeBag()

//let source = Observable<String>.create { observer in
//    let url = URL(string: "https://tistory.com")!
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        if let data = data,
//           let html = String(data: data, encoding: .utf8) {
//            observer.onNext(html)
//        }
//        observer.onCompleted()
//    }
//    task.resume()
//    return Disposables.create {
//        task.cancel()
//    }
//}
//.debug()
//.share() // -> 구독을 공유해야 한다.
//
//// 공유를 하지 않으면 불필요한 리소스가 낭비된다
//// 구독이 공유되는 것이 아니라 3번 실행된다.
//source.subscribe().disposed(by: bag)
//source.subscribe().disposed(by: bag)
//source.subscribe().disposed(by: bag)



// MARK: - multicast, Connectable Observable

// 첫 번째 파라미터인 subject는 원본 옵저버블이 방출하는 이벤트를 등록된 다수의 옵저버블에게 전달한다.
// ConnectableObservable : 구독자가 추가되어도 시퀀스가 시작되는 게 아니라, connect 메소드가 호출되는 시점에 호출

//let subject = PublishSubject<Int>()
//
//// 원본 옵저버블
//let source1 = Observable<Int>
//    .interval(.seconds(1), scheduler: MainScheduler.instance)
//    .take(5)
//    .multicast(subject) // -> 이 subject를 말하는 것!
//
//source1
//    .subscribe { print("💎", $0) }
//    .disposed(by: bag)
//
//source1
//    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe { print("🪙", $0) }
//    .disposed(by: bag)

/* connect() 메소드를 호출하는 순간
원본 옵저버블에서 시퀀스가 시작되고 나면 모든 이벤트는 파라미터로 전달한 subject로 전달되고,
등록한 모든 구독자에게 이벤트를 전달한다.
 */
//source1.connect()

// 모든 구독자가 원본 옵저버블을 공유한다.
//구독이 지연된 3초 동안 원본 옵저버블이 전달한 2개의 이벤트는 2번째 구독자에게 전달이 안된다.
//💎 next(0)
//💎 next(1)
//💎 next(2) - 시퀀스 공유 시작
//🪙 next(2)
//💎 next(3)
//🪙 next(3)
//💎 next(4)
//🪙 next(4)
//💎 completed
//🪙 completed

// multicast는 subject를 직접 만들고, connect를 직접 호출해야 한다는 번거로움이 있다.

// multicast를 하지 않았을 경우
// 각각의 시퀀스를 가지고 있음
//💎 next(0)
//💎 next(1)
//💎 next(2)
//💎 next(3)
//🪙 next(0)
//💎 next(4)
//💎 completed
//🪙 next(1)
//🪙 next(2)
//🪙 next(3)
//🪙 next(4)
//🪙 completed


// MARK: - Publish : PublishSubject를 활용해서 구독을 공유


// 내부에서 publish 연산자를 생성하고 multicast를 작동시키기 때문에
// multicast처럼 따로 publishSubject를 만들지 않아도 된다.
// connect() 메소드를 호출해야 하는 것은 똑같다.
// 결과는 multicast와 같다.

// 원본 옵저버블
//let source2 = Observable<Int>
//    .interval(.seconds(1), scheduler: MainScheduler.instance)
//    .take(5)
//    .publish()
//
//source2
//    .subscribe { print("💎", $0) }
//    .disposed(by: bag)
//
//source2
//    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe { print("🪙", $0) }
//    .disposed(by: bag)
//
//source2.connect()

//💎 next(0)
//🪙 next(0)
//💎 next(1)
//🪙 next(1)
//💎 next(2)
//🪙 next(2)
//💎 next(3)
//🪙 next(3)
//💎 next(4)
//🪙 next(4)
//💎 completed
//🪙 completed


// MARK: - replay : Connectable 옵저버블에게 버퍼를 추가하고 새로운 구독자에게 최근 이벤트를 전달하는 법

// 만약 2번째 구독자에게 구독 전 이벤트도 전달하고 싶다면?

let replaySubject = ReplaySubject<Int>.create(bufferSize: 5)
//let source3 = Observable<Int>
//    .interval(.seconds(1), scheduler: MainScheduler.instance)
//    .take(5)
//    .multicast(replaySubject)


// replaySubject를 써도 되지만, replay 연산자를 써도 된다.
// multicast로 replaySubject를 전달한다.
// replayAll은 메모리 사용이 증가하기에 특별한 이유가 없다면 가능하면 사용하지 않아야 한다.


let sourceReplay = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(5)
    .replay(5) // 필요이상으로 크게 지정하면 메모리에 문제가 발생한다.

sourceReplay
    .subscribe { print("💎", $0) }
    .disposed(by: bag)

sourceReplay
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🪙", $0) }
    .disposed(by: bag)

//sourceReplay.connect()

// MARK: - refCount연산자와 RefCount 옵저버블

// ObservableType이 아닌 ConnectableObservableType에서 사용할 수 있다.
// 옵저버블을 반환한다.
// 새로운 구독자가 추가되는 시점에 ConnectableObservable을 호출한다.
// 자동으로 connect를 호출한다.

//let refSource = Observable<Int>
//    .interval(.seconds(1), scheduler: MainScheduler.instance)
//    .debug()
//    .publish()
//    .refCount()
//
//let observer1 = refSource
//    .subscribe(onDisposed:  { print("🧿") })
//
//
//DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//    observer1.dispose()
//}
//
//DispatchQueue.main.asyncAfter(deadline: .now()+7) {
//    let observer2 = refSource.subscribe { print("🧨", $0) }
//
//    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//        observer2.dispose()
//    }
//}


// MARK: - share 구독 공유

// 이전에 나온 연산자들을 활용한 것임

// multicast로 하나의 시퀀스를 공유하고 바로 refCount를 호출,
//즉. 새로운 구독자가 추가되면 connect되고, 없으면 disconnect된다.
// replay 버퍼의 크기
// - 0을 전달하면 : publishSubject (기본값)
// - 0보다 크면 : ReplaySubject

// scope -
// - .whileConnected : 새로운 구독자가 추가되면 subject가 새로 추가된다.
// - .forever : 모든 구독자가 하나의 subject를 공유한다.


// share 옵저버블은 refCount Observable
let shareSource =
Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .debug()
    .share()
//    .share(replay: 5, scope: .forever)

let shareObserver1 = shareSource
    .subscribe { print("구독1", $0) }

let shareObserver2 = shareSource
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("구독2", $0) }

// 5초 뒤 모든 구독이 종료되면 내부의 connectable observable도 중지된다.
// share 연산자 내부에서 refCount 호출하고 있음

DispatchQueue.main.asyncAfter(deadline: .now()+5) {
    shareObserver1.dispose()
    shareObserver2.dispose()
}

/*
 2023-03-22 00:00:39.027: Sharing.playground:211 (__lldb_expr_28) -> subscribed
2023-03-22 00:00:40.031: Sharing.playground:211 (__lldb_expr_28) -> Event next(0)
구독1 next(0)
2023-03-22 00:00:41.030: Sharing.playground:211 (__lldb_expr_28) -> Event next(1)
구독1 next(1)
2023-03-22 00:00:42.030: Sharing.playground:211 (__lldb_expr_28) -> Event next(2)
구독1 next(2)
2023-03-22 00:00:43.031: Sharing.playground:211 (__lldb_expr_28) -> Event next(3)

 2번째 파라미터와 관련된 것))
 새로운 구독자가 추가되면, subject를 생성하고, 이어진 구독자들은 이 subject를 구독한다.
 그래서 1, 2번째 구독자가 동일한 subject로부터 같은 이벤트를 전달받음
 
구독1 next(3)
구독2 next(3)
2023-03-22 00:00:44.031: Sharing.playground:211 (__lldb_expr_28) -> Event next(4)
구독1 next(4)
구독2 next(4)
2023-03-22 00:00:44.294: Sharing.playground:211 (__lldb_expr_28) -> isDisposed -> subject가 사라지고,
*/

// 2023-03-22 00:00:46.401: Sharing.playground:211 (__lldb_expr_28) -> subscribed
// 새로운 subject가 생성된다.
// connectable observable에서 새로운 시퀀스가 시작된다. -> 구독3 next(0)

DispatchQueue.main.asyncAfter(deadline: .now()+7) {
    let shareObserver3 = shareSource.subscribe { print("구독3", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
        shareObserver3.dispose()
    }
}




/*
2023-03-22 00:08:56.326: Sharing.playground:211 (__lldb_expr_32) -> subscribed
2023-03-22 00:08:57.329: Sharing.playground:211 (__lldb_expr_32) -> Event next(0)
구독1 next(0)
2023-03-22 00:08:58.328: Sharing.playground:211 (__lldb_expr_32) -> Event next(1)
구독1 next(1)
2023-03-22 00:08:59.328: Sharing.playground:211 (__lldb_expr_32) -> Event next(2)
구독1 next(2)
구독2 next(0)
구독2 next(1)
구독2 next(2)
2023-03-22 00:09:00.328: Sharing.playground:211 (__lldb_expr_32) -> Event next(3)
구독1 next(3)
구독2 next(3)
2023-03-22 00:09:01.328: Sharing.playground:211 (__lldb_expr_32) -> Event next(4)
구독1 next(4)
구독2 next(4)
2023-03-22 00:09:01.582: Sharing.playground:211 (__lldb_expr_32) -> isDisposed
 
 replay로 바꾸고,
 scope를 .forever로 바꿔줄 경우에는
 하나의 subject를 공유하기 때문에 이전 시퀀스의 버퍼를 받아올 수 있다.
 
구독3 next(0)
구독3 next(1)
구독3 next(2)
구독3 next(3)
구독3 next(4)
2023-03-22 00:09:03.360: Sharing.playground:211 (__lldb_expr_32) -> subscribed
2023-03-22 00:09:04.361: Sharing.playground:211 (__lldb_expr_32) -> Event next(0)
구독3 next(0)
2023-03-22 00:09:05.362: Sharing.playground:211 (__lldb_expr_32) -> Event next(1)
구독3 next(1)
2023-03-22 00:09:06.362: Sharing.playground:211 (__lldb_expr_32) -> Event next(2)
구독3 next(2)
2023-03-22 00:09:06.525: Sharing.playground:211 (__lldb_expr_32) -> isDisposed
*/
