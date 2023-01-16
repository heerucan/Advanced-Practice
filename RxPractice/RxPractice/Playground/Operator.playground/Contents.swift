import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

// MARK: - 구독공유

//let source = Observable<String>.create { observer in
//    let url = URL(string: "https://roniruny.tistory.com")!
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        if let data = data, let html = String(data: data, encoding: .utf8) {
//            observer.onNext(html) // 전달된 문자열을 방출
//        }
//
//        observer.onCompleted()
//    }
//
//    task.resume()
//
//    return Disposables.create {
//        task.cancel()
//    }
//}
//.debug()
//.share()
//
///// 구독자 3개 추가
//source.subscribe().disposed(by: disposeBag) // 시퀀스 추가
//source.subscribe().disposed(by: disposeBag)
//source.subscribe().disposed(by: disposeBag)

/* 이 경우에 3번 네트워크 요청이 실행된다. 구독자가 추가되면 새로운 시퀀스가 추가된다. */

print()
print("Map=========================================")
print()

// MARK: - Map 연산자

// 옵저버블이 배출하는 항목을 대상으로 함수를 실행하고 결과를 방출
let skills = ["Swift", "SwiftUI", "RxSwift"]

Observable.from(skills)
//    .map { "Hello, \($0)" }
    .map { $0.count }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

print()
print("FlatMap=========================================")
print()

// MARK: - FlatMap 연산자

let redCircle = "🔴"
let greenCircle = "🟢"
let blueCircle = "🔵"

let redHeart = "❤️"
let greenHeart = "💚"
let blueHeart = "💙"

Observable.from([redCircle, greenCircle, blueCircle])
    .flatMap { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart).take(5) // inner Observable
        case greenCircle:
            return Observable.repeatElement(greenHeart).take(5) // inner Observable
        case blueCircle:
            return Observable.repeatElement(blueHeart).take(5) // inner Observable
        default:
            return Observable.just("") // inner Observable
        }
    }
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)


print()
print("FlatMapFirst=========================================")
print()

// MARK: - FlatMapFirst

Observable.from([redCircle, greenCircle, blueCircle])
    .flatMapFirst { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart).take(5) // inner Observable
        case greenCircle:
            return Observable.repeatElement(greenHeart).take(5) // inner Observable
        case blueCircle:
            return Observable.repeatElement(blueHeart).take(5) // inner Observable
        default:
            return Observable.just("") // inner Observable
        }
    }
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

print()
print("FlatMapLatest=========================================")
print()

// MARK: - FlatMapLatest

Observable.from([redCircle, greenCircle, blueCircle])
    .flatMapLatest { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart).take(5) // inner Observable
        case greenCircle:
            return Observable.repeatElement(greenHeart).take(5) // inner Observable
        case blueCircle:
            return Observable.repeatElement(blueHeart).take(5) // inner Observable
        default:
            return Observable.just("") // inner Observable
        }
    }
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)


print()
print("CombineLatest=========================================")
print()

// MARK: - CombineLatest

enum MyError: Error {
    case error
}

let greetings = PublishSubject<String>()
let languages = PublishSubject<String>()

Observable
    .combineLatest(greetings, languages) { first, second -> String in
        return "\(first) \(second)"
    }
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

greetings.onNext("Hi")
languages.onNext("RuheeKim") // next(Hi RuheeKim)

greetings.onNext("안녕") //next(안녕 RuheeKim)
languages.onNext("후리방구") // next(안녕 후리방구)
languages.onCompleted() //

// language 소스 옵저버블이 complete 이벤트를 전달해도 greeting 소스 옵저버블이 complete 이벤트를 전달하지 않았기 때문에
greetings.onNext("Bye") // next(Bye 후리방구)
greetings.onCompleted() // completed

/// languages.onError(MyError.error) // 하나라도 error event면 즉시 error 전달

print()
print("Zip=========================================")
print()

// MARK: - Zip

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

Observable.zip(numbers, strings) { "\($0) - \($1)" }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

numbers.onNext(1)
strings.onNext("One")
// next(1 - One)

numbers.onNext(2)
// 만약 combineLatest 였다면 next(2 - One)이라고 출력됐을 거임

strings.onNext("Two")
// next(2 - Two)

//numbers.onCompleted()
numbers.onError(MyError.error)
strings.onNext("Three")
// Three와 결합할 numbers 소스 옵저버블이 방출하는 이벤트가 없음

strings.onCompleted()
// completed
