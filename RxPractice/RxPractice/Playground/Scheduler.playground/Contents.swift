import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

// 일반적으로 여기서 작성한 모든 코드는 Main Thread에서 실행됨
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)

print("==================== 스케줄러 바꿔줌 =======================")

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .subscribe(on: MainScheduler.instance)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observe(on: backgroundScheduler)
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .observe(on: MainScheduler.instance)
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: disposeBag)
