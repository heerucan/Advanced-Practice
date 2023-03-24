import UIKit

import RxSwift

let bag = DisposeBag()

// MARK: - toArray : 원본 옵저버블이 방출하는 모든 요소를 하나의 배열로 바꿔서 방출해줌

let numbers = [1,2,3,4,5,6,7,8,9,10]

let subject = PublishSubject<Int>()

subject
    .toArray() // single로 변환, 하나의 요소로 변환
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onNext(1)
subject.onNext(2)
subject.onCompleted() // -> completed해주기 전까지 출력안함
//success([1, 2])

// MARK: - map : 원본 옵저버블이 방출하는 요소를 대상으로 함수를 실행하고, 결과를 새로운 옵저버블로 리턴

let skills = ["ruhee", "hee", "kim"]

Observable.from(skills)
//    .map { "Hi, " + $0 }
    .map { $0.count }
    .subscribe { print($0) }
    .disposed(by: bag)

//next(Hi, ruhee)
//next(Hi, hee)
//next(Hi, kim)
//next(5)
//next(3)
//next(3)


// MARK: - compactMap : nil을 필터링하는 연산자

let subject1 = PublishSubject<String?>()

subject1
//    .filter { $0 != nil }
//    .map { $0! }
    .compactMap { $0 } // -> 위 filter, map을 한 번에 써서 nil을 필터링하고 값은 언래핑한 것
    .subscribe { print($0) }
    .disposed(by: bag)

//Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
//    .take(10)
//    .map { _ in Bool.random() ? "별" : nil }
//    .subscribe {
//        subject1.onNext($0)
//    }
//    .disposed(by: bag)
//next(별)
//next(별)
//next(별)
//next(별)


// MARK: - flatMap :

/*
 내부에 있는 inner observable들을 합치는 flattening 이 발생하고,
 그로 인한 result observable이 나옴
 
 observable + flatMap을 통해 모든 innerObservable을 합쳐서 -> ResultObservable을 반환
 */

//let redCircle = "🔴"
//let greenCircle = "🟢"
//let blueCircle = "🔵"

//let redHeart = "❤️"
//let greenHeart = "💚"
//let blueHeart = "💙"
//
//Observable.from([redCircle, greenCircle, blueCircle])
//    .flatMap { circle -> Observable<String> in
//        switch circle {
//        case redCircle:
//            return Observable.repeatElement(redHeart).take(5) // inner Observable
//        case greenCircle:
//            return Observable.repeatElement(greenHeart).take(5) // inner Observable
//        case blueCircle:
//            return Observable.repeatElement(blueHeart).take(5) // inner Observable
//        default:
//            return Observable.just("") // inner Observable
//        }
//    }
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: bag)
//
//// inner observable을 통해서 result를 내보내면interleaving 지연없이 방출돼서 순서가 섞임
////next(❤️)
////next(❤️)
////next(💚)
////next(❤️)
////next(💚)
////next(💙)
////next(❤️)
////next(💚)
////next(💙)
////next(❤️)
////next(💚)
////next(💙)
////next(💚)
////next(💙)
////next(💙)



// MARK: - flatMapFirst : 가장 먼저 이벤트를 방출한 이너 옵저버블에서만 이벤트를 방출하는 연산자


let redCircle1 = "🔴"
let greenCircle1 = "🟢"
let blueCircle1 = "🔵"

let redHeart1 = "❤️"
let greenHeart1 = "💚"
let blueHeart1 = "💙"

Observable.from([redCircle1, greenCircle1, blueCircle1])
    .flatMapFirst { circle -> Observable<String> in
        switch circle {
        case redCircle1: // redCircle 이너 옵저버블이 가장 먼저 방출 -> 그래서 이것만 사용
            return Observable.repeatElement(redHeart1).take(5) // inner Observable
        case greenCircle1:
            return Observable.repeatElement(greenHeart1).take(5) // inner Observable
        case blueCircle1:
            return Observable.repeatElement(blueHeart1).take(5) // inner Observable
        default:
            return Observable.just("") // inner Observable
        }
    }
    .subscribe {
        print($0)
    }
    .disposed(by: bag)


//next(❤️)
//next(❤️)
//next(❤️)
//next(❤️)
//next(❤️)


// MARK: - 두 번째 케이스

let disposeBag = DisposeBag()

let redCircle2 = "🔴"
let greenCircle2 = "🟢"
let blueCircle2 = "🔵"

let redHeart2 = "❤️"
let greenHeart2 = "💚"
let blueHeart2 = "💙"

let sourceObservable = PublishSubject<String>()

sourceObservable
    .flatMapFirst { circle -> Observable<String> in
        switch circle { // 이너 옵저버블은 0.2초 주기로 10개의 하트 방출
        case redCircle2:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in redHeart2}
                .take(10)
        case greenCircle2:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in greenHeart2}
                .take(10)
        case blueCircle2:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in blueHeart2}
                .take(10)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

sourceObservable.onNext(redCircle2)

//가장 먼저 이벤트를 방출한 것이 바로 First

// 0.5초 주기를 두고 방출
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    sourceObservable.onNext(greenCircle2)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
    sourceObservable.onNext(blueCircle2)
}




// MARK: - flatMapLatest : 가장 최근 이너 옵저버블에서만 이벤트를 방출하는 경우


let redCircle3 = "🔴"
let greenCircle3 = "🟢"
let blueCircle3 = "🔵"

let redHeart3 = "❤️"
let greenHeart3 = "💚"
let blueHeart3 = "💙"

let sourceObservable3 = PublishSubject<String>() // circle 방출
let trigger3 = PublishSubject<Void>() // take(until:)에서 Trigger로 사용

sourceObservable3
    .flatMapLatest { circle -> Observable<String> in
        switch circle {
        case redCircle3:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in redHeart3}
                .take(until: trigger3)
        case greenCircle3:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in greenHeart3}
                .take(until: trigger3)
        case blueCircle3:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in blueHeart3}
                .take(until: trigger3)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

sourceObservable3.onNext(redCircle3) // 빨강 하트 처음 방출

// 1초 뒤에 초록색 방출하면, 새로운 이너 옵저버블이 생성돼서 기존 빨강하트를 방출하던 이너옵저버블은 즉시 종료됨
DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    sourceObservable3.onNext(greenCircle3)
}

// 그 후 다시 1초 뒤에 파랑 방출
// 다시 여기에서 파랑을 방출하면, 초록 이너 옵저버블은 사라지고, 새로운 이너옵저버블이 파란색을 방출한다.
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    sourceObservable3.onNext(blueCircle3)
}

// 다시 3초 후에 빨강을 방출하면 이제 빨강이 나와~!
// 첫 번째 이너 옵저버블을 재사용하는 것은 아님 -> 항상 기존에 있던 옵저버블을 제거함
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    sourceObservable3.onNext(redCircle3)
}

// 트리거가 방출하기 전까지 방출한다.

DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    trigger3.onNext(()) // 10초 뒤 모든 이너 옵저버블 중지
}

// latest라는 것이 최근 이라는 것이니까 결국에 가장 최근 것의 옵저버블이 방출 시에 기존 이너 옵저버블은 방출 종료
/*
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(💚)
 next(💚)
 next(💚)
 next(💚)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)

 */



// MARK: - concatMap : 인터리빙을 허용하지 않는 (flatMap과 다른 점)

// flatMap은 이너 옵저버블이 이벤트를 방출하면 결과 옵저버블도 즉시 방출하기 때문에 순서가 섞인다.
// concatMap은 끼어들기가 불가능하다. -> 이너 옵저버블을 생성된 순서대로 연결한다.


let redCircle4 = "🔴🔴"
let greenCircle4 = "🟢🟢"
let blueCircle4 = "🔵🔵"

let redHeart4 = "❤️❤️"
let greenHeart4 = "💚💚"
let blueHeart4 = "💙💙"

Observable.from([redCircle4, greenCircle4, blueCircle4])
    .concatMap { circle -> Observable<String> in
        switch circle {
        case redCircle4:
            return Observable.repeatElement(redHeart4)
                .take(5)
        case greenCircle4:
            return Observable.repeatElement(greenHeart4)
                .take(5)
        case blueCircle4:
            return Observable.repeatElement(blueHeart4)
                .take(5)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(❤️❤️)
 next(❤️❤️)
 next(❤️❤️)
 next(❤️❤️)
 next(❤️❤️)
 next(💚💚)
 next(💚💚)
 next(💚💚)
 next(💚💚)
 next(💚💚)
 next(💙💙)
 next(💙💙)
 next(💙💙)
 next(💙💙)
 next(💙💙)
 */




// MARK: - scan : accumulator function을 활용

// 기본값으로 연산을 실행

Observable.range(start: 1, count: 10)
    .scan(0, accumulator: +)
    .subscribe { print($0) }
    .disposed(by: bag)

//next(1) -> 옵저버블이 1을 방출하면, 클로저로 기본값 0과 1이 전달돼서 0+1
//next(3) -> 옵저버블이 2를 방출하면, 이전값1과 옵저버블2 더해서 3이 구독자에게 전달됨
//next(6) -> 3+3 = 6
//next(10) -> 6+4 = 10
//next(15) -> 10+5 = 15
//next(21)
//next(28)
//next(36)
//next(45)
//next(55)


// MARK: - reduce는 combine operator인데 scan과 비교를 위해 여기에 작성
// MARK: - reduce 시드 값과 옵저버블이 방출하는 요소를 대상으로 클로저를 실행하고 최종 결과를 옵저버블로 방출

let o = Observable.range(start: 1, count: 5)

// 중간연산과 최종결과
o.scan(0, accumulator: +)
    .subscribe { print($0)}
    .disposed(by: bag)
//next(1)
//next(3)
//next(6)
//next(10)
//next(15)

// scan과 다른 것은 result observable만 방출한다는 것!
o.reduce(0, accumulator: +)
    .subscribe { print($0)}
    .disposed(by: bag)
//next(15)



// MARK: - Buffer : controlled buffering 구현에 이용되는 것
// 특정 주기 동안 옵저버블이 방출하는 이벤트를 수집하고 하나로 방출한다. = controlled buffering


// timeSpan : 항목을 수집할 시간임 - 시간이 경과하지 않을 시에도 방출은 가능
// count : 수집할 항목의 숫자 - 특정 숫자가 아닌 범위 같은 최대숫자임
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(3), count: 3, scheduler: MainScheduler.instance)
    .take(5) // 5개로 제한해서 방출, 안하면 무한대로 방출됨
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// 1초마다 옵저버블은 방출하고, 버퍼 연산자는 2초마다 3개만큼 수집해서 방출한다.
// 그럴 경우에, 보통 2개의 요소가 포함된 것을 방출

// timeSpan을 늘리면 더 많은 요소 수집
//next([0, 1])
//next([2, 3, 4])
//next([5, 6, 7])
//next([8, 9, 10])
//next([11, 12, 13])


// MARK: - window

//원본이 방출하는 걸 작은단위로 분해한다. -> 수집된 항목을 '옵저버블'로 방출
//buffer는 요소를 방출했었음. buffer연산자와의 차이. 배열을 방출하지만, window는 inner observable을 방출함.
// 지정된 시간이 경과하면 completed 전달하고 종료

Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe {
        if let observable = $0.element {
            observable.subscribe {
                print("inner>>", $0)
            }
        }
    }
    .disposed(by: disposeBag)

//AddRef는 이너옵저버블임
//next(RxSwift.AddRef<Swift.Int>)
//next(RxSwift.AddRef<Swift.Int>)
//next(RxSwift.AddRef<Swift.Int>)
//next(RxSwift.AddRef<Swift.Int>)
//next(RxSwift.AddRef<Swift.Int>)
//completed

/*
 5초라는 기간 동안 최대 3개의 이벤트를 방출하는 옵저버블을 방출
 5초라는 기간이 충분해서 3개가 다 나올 수 있는 것임.
 inner>> next(0)
 inner>> next(1)
 inner>> next(2)
 inner>> completed
 inner>> next(3)
 inner>> next(4)
 inner>> next(5)
 inner>> completed
 inner>> next(6)
 inner>> next(7)
 inner>> next(8)
 inner>> completed
 inner>> next(9)
 inner>> next(10)
 inner>> next(11)
 inner>> completed
 inner>> next(12)
 inner>> next(13)
 inner>> next(14)
 inner>> completed

 */



// MARK: - groupBy : 방출되는 요소를 조건에 따라 그룹핑하는 것

let words = ["루루", "소소", "하하하", "으으으으", "히히히", "카카카카"]

// 옵저버블이 방출됨.

Observable.from(words)
    .groupBy { $0.count }
    .subscribe(onNext: { groupedObservable in
        print("----->>", groupedObservable.key)
        
        // inner observable에 구독자 추가
        groupedObservable.subscribe { print("---------->> ", $0) }
    })
    .disposed(by: disposeBag)

/*
 next(GroupedObservable<Int, String>(key: 2, source: RxSwift.(unknown context at $11a23a8a8).GroupedObservableImpl<Swift.String>))
 next(GroupedObservable<Int, String>(key: 3, source: RxSwift.(unknown context at $11a23a8a8).GroupedObservableImpl<Swift.String>))
 next(GroupedObservable<Int, String>(key: 4, source: RxSwift.(unknown context at $11a23a8a8).GroupedObservableImpl<Swift.String>))
 
 ----->> 2
 ---------->>  next(루루)
 ---------->>  next(소소)
 ----->> 3
 ---------->>  next(하하하)
 ----->> 4
 ---------->>  next(으으으으)
 ---------->>  next(히히히)
 ---------->>  next(카카카카)
 */




// 보통, toArray, flatMap을 사용해서 그룹핑된 배열을 만들어서 방출

Observable.from(words)
    .groupBy { $0.count }
    .flatMap { $0.toArray() }
    .subscribe { print("******************** ", $0) }
    .disposed(by: disposeBag)
/*
 ********************  next(["루루", "소소"])
 ********************  next(["하하하", "히히히"])
 ********************  next(["으으으으", "카카카카"])
 ********************  completed
 */

Observable.range(start: 1, count: 10)
    .groupBy { $0.isMultiple(of: 2) }
    .flatMap { $0.toArray() }
    .subscribe { print("@@@@@@@@@@@@@@ ", $0) }
    .disposed(by: disposeBag)

/*
 @@@@@@@@@@@@@@  next([1, 3, 5, 7, 9])
 @@@@@@@@@@@@@@  next([2, 4, 6, 8, 10])
 */
