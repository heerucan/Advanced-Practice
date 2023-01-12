import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// next 이벤트만 전달한다는 것!
// 종료되지 않는다는 특징! 구독자가 dispose되기 전까지 ~ 그래서 UI에서 사용됨

// MARK: - PublishRelay

let p = PublishRelay<Int>()

p.subscribe {
    print("1:", $0)
}
.disposed(by: disposeBag)

p.accept(1)


// MARK: - BehaviorRelay

let b = BehaviorRelay<Int>(value: 0)

b.accept(2)

b.subscribe {
    print("2:", $0)
}
.disposed(by: disposeBag)

b.accept(3)
print(b.value) // 마지막 이벤트에 저장된 값을 출력 - 읽기 전용이라 바꿀 수 없음


// MARK: - ReplayRelay

let r = ReplayRelay<Int>.create(bufferSize: 3)

(1...10).forEach { r.accept($0) }
r.subscribe {
    print("3:", $0)
}
.disposed(by: disposeBag)

