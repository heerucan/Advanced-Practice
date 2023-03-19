import UIKit

import RxSwift

let bag = DisposeBag()

// MARK: - interval 지정된 주기마다 정수를 방출

// period : 반복주기
// scheduler : 정수를 방출할 스케줄러
// 지정된 주기마다 정수를 계속해서 방출한다. 즉, 무한한 시퀀스를 생성하는 것! -> 직접 dispose를 해줘야 함
// int를 포함한 모든 정수형식을 사용가능하다.

let i = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

let subscription1 = i.subscribe { print("1 >> \($0)") }

// 별도로 종료시키는 것이 없기에 따로 dispose를 통해서 5초 뒤에 종료시켜준다.
DispatchQueue.main.asyncAfter(deadline: .now()+5) {
    subscription1.dispose()
}

// 새로운 구독이 시작되면 내부에 있는 타이머가 시작된다.
var subscription2: Disposable?

// 2초 뒤에 subscription2의 구독을 시작한다.
DispatchQueue.main.asyncAfter(deadline: .now()+2) {
    subscription2 = i.subscribe { print("2 >> \($0)") }
}

// 5초 뒤에 subscription2의 구독을 해제한다.
DispatchQueue.main.asyncAfter(deadline: .now()+5) {
    subscription2?.dispose()
}

// 1초
//1 >> next(0)

// 2초
//1 >> next(1)

// 3초 (2초 후 subscription2 시작!!)
//1 >> next(2)
//2 >> next(0)

// 4초
//1 >> next(3)
//2 >> next(1)

// 5초
//1 >> next(4)

// 6초
// (5초 후 subscription1 종료)
// (5초 후 subscription2 종료)


// MARK: - timer 지연시간과 반복 주기를 지정해서 정수를 방출

// dueTime : 첫 번째 요소가 구독자에게 전달되는 시간
// period : 반복주기 (기본값 nil)

// .seconds(1)는 첫 번째 요소가 구독자에게 전달되는 상대적인 시간. 구독 후 1초 뒤에 전달된다!
Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

// 1초 뒤에 0이 전달되고 completed가 전달되고 종료된다.
//next(0)
//completed

// 두 번째 파라미터 0.5초를 넣어주면 -> 0.5초마다 요소가 전달
let timerObservable = Observable<Int>.timer(.seconds(1), period: .milliseconds(500), scheduler: MainScheduler.instance)
    .subscribe { print("timer + period ->>", $0) }

// 1초 뒤에 첫 번째 요소가 전달되고 그 후부터 0.5초마다 1씩 값이 증가하면서 전달
//timer + period ->> next(0)
//timer + period ->> next(1)
//timer + period ->> next(2)
//timer + period ->> next(3)
//timer + period ->> next(4)
//timer + period ->> next(5)
//timer + period ->> next(6)
//timer + period ->> next(7)
//timer + period ->> next(8)
// ........

// 무한시퀀스라서 타이머 중지를 위해서는 직접 dispose를 해줘야 한다.
DispatchQueue.main.asyncAfter(deadline: .now()+5) {
    timerObservable.dispose()
}


// MARK: - timeout 지정된 시간 이내에 요소를 방출하지 않으면 에러 이벤트를 전달

let subject = PublishSubject<Int>()

// dueTime: 이 시간(timeout 시간) 내에 요소 방출하지 않으면 에러 이벤트를 전달
// 이 시간 내에 새로운 이벤트를 전달하면 구독자에게 그대로 전달
// other : 새로운 옵저버블을 전달


// timeout 시간을 3초로 지정
subject.timeout(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)


// 1.
// 1초 후 첫 번째 요소를 전달하고 그 후 1초 주기로 계속 이벤트를 전달
// 그렇기 때문에 timeout 시간 내에 이벤트를 전달해서 에러가 나지 않음
Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)


// 2.
// 만약 첫 번째 이벤트를 보내는 시간을 5초로 바꾸면 에러 이벤트
Observable<Int>.timer(.seconds(5), period: .seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)

//error(Sequence timeout.)


// 3.
// 3초 내에 첫 번째 이벤트를 보내고 그 다음 이벤트는 5초 후에 보내면
// -> 처음엔 next -> 그 다음에는 error
Observable<Int>.timer(.seconds(2), period: .seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)

//next(0)
//error(Sequence timeout.)



// 4.
subject.timeout(.seconds(3), other: Observable.just(0), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

Observable<Int>.timer(.seconds(2), period: .seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)

//next(0) -> 처음 subject가 전달하는 이벤트
//next(0) -> 5초 뒤에 전달되는 이벤트이기 때문에 Observable.just(0)가 구독자에게 전달
//completed




// MARK: - delay : next 이벤트가 전달되는 시점과 구독이 시작되는 시점을 지연시키는 방법

// dueTime : 지연시킬 시간

func currentTimeString() -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
    return f.string(from: Date())
}

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delay(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: bag)

// 구독시점은 21초, 전달시점은 26초 -> 5초 지연
//2023-03-20 00:50:21.414: TimeBased.playground:166 (__lldb_expr_56) -> Event next(0)
//2023-03-20 00:50:22.412: TimeBased.playground:166 (__lldb_expr_56) -> Event next(1)
//2023-03-20 00:50:23.413: TimeBased.playground:166 (__lldb_expr_56) -> Event next(2)
//2023-03-20 00:50:24.413: TimeBased.playground:166 (__lldb_expr_56) -> Event next(3)
//2023-03-20 00:50:25.413: TimeBased.playground:166 (__lldb_expr_56) -> Event next(4)
//2023-03-20 00:50:26.414: TimeBased.playground:166 (__lldb_expr_56) -> Event next(5)
//2023-03-20 00:50:26.4200 next(0)


// MARK: - delaySubscription

// 7초 동안은 아무 일도 일어나지 않다가 7초 후에 지연없이 구독자에게 전달
// 구독시점만 지연, next event가 전달되는 것은 지연시키지 않는다.
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delaySubscription(.seconds(7), scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: bag)

// delay와 다르게 구독시점과 전달시점 둘 다 동일
//2023-03-20 00:52:44.715: TimeBased.playground:182 (__lldb_expr_58) -> Event next(0)
//2023-03-20 00:52:44.7170 next(0)
