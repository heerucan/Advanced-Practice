import UIKit
import RxSwift

let disposeBag = DisposeBag()

Observable.just("Hello, RxSwift")
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// MARK: - 옵저버블을 생성하는 연산자
// #1 create
let firstObservable = Observable<Int>.create { observer -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    observer.onCompleted() // 옵저버블이 종료
    return Disposables.create() // 메모리정리에 필요한 객체 : Disposable
}


// MARK: - 옵저버블이 전달하는 이벤트가 제대로 전달되는 시점은 옵저버가 구독을 시작할 때!
/// 그 방법은 subscribe 메소드를 통해서 가능 : 옵저버블과 옵저버 두 요소를 연결!

/// #1 클로저에서 이벤트가 전달됨! 이 클로저가 옵저버임
firstObservable.subscribe {
    print("==start==")
    print($0)
    
    // 이벤트에 저장되어 있는 값을 사용할 수 있는 방법
    if let elem = $0.element {
        print(elem)
    }
    print("==end==")
}

// #2 바로 위처럼 element 속성에 접근하지 않아도 이벤트에 저장되어 있는 값(요소)을 사용할 수 있음
firstObservable.subscribe(onNext: { elem in
    print("==start==")
    print(elem)
    print("==end==")
})

// MARK: - 옵저버블은 옵저버가 하나의 이벤트를 전달받아 처리한 후에 그 다음 이벤트를 전달함!
/// 즉, 옵저버는 한 개씩 이벤트를 전달받아 처리한다!

// #2 from 배열 요소를 순서대로 방출
Observable.from([0, 1])
    
/// 이 상태에서는 옵저버블을 생성만 한 상태임. 방출되거나 이벤트가 전달되진 않음.
/// 옵저버가 옵저버블을 구독하는 시점에야만 이벤트가 전달됨


// MARK: - Disposables에 대해

let subscription1 = Observable.from([1, 2, 3])
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError:  { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

subscription1.dispose() // 리소스를 해제하는 방식1

var bag = DisposeBag()

Observable.from([1, 2, 3])
    .subscribe {
        print($0)
    }
    .disposed(by: bag)

bag = DisposeBag()


// MARK: - Subscribe를 실행취소로 사용하는 경우

let subscription2 = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError:  { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose() // 모든 리소스가 해제됨 -> completed 이벤트가 전달X
}

// MARK: - Operator

Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
    .take(5)
    .filter { $0.isMultiple(of: 2) }
    .subscribe { print($0) }
    .disposed(by: bag)

