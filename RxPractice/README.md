# About Reactive Programming

## 1. RxPractice 정리

- [1. Observable과 Observer](https://roniruny.tistory.com/266)
- [2. Share()를 통한 구독 공유](https://roniruny.tistory.com/267)
- [3. Scheduler](https://roniruny.tistory.com/268)
- [4. Error Handling - catch, catchAndReturn, retry](https://roniruny.tistory.com/269) ⭐️
- [5. RxCocoa (feat. TableView, CollectionView)](https://roniruny.tistory.com/270)
- [6. Binder](https://roniruny.tistory.com/271) ⭐️
- [7. Traits - ControlProperty, ControlEvent, Driver](https://roniruny.tistory.com/272) ⭐️
- [8. DelegateProxy](https://roniruny.tistory.com/278) ⭐️
- [NSObject+Rx](https://roniruny.tistory.com/279?category=1078537)

<br>

## 2. Rx Operator 시리즈
- [map](https://roniruny.tistory.com/273)
- [combineLatest](https://roniruny.tistory.com/274)
- [zip](https://roniruny.tistory.com/275)
* **flatMap**은 방출된 항목의 값이 바뀌면 새로운 항목을 방출한다.
이해한 바로는 flatMap은 모든 옵저버블이 값을 방출할 때마다 그 값들을 가지고 있다가 최종적으로 하나의 옵저버블로 합쳐주는 동작. (나랑 본순이 키가 클 때마다 모든 키를 기록해서 다 방출하는 그런 느낌 같다.) -> 네트워크 처리에서 자주 쓰임
* **flatMapLatest**는 내가 태어나서 내 키를 계속 기록해주다가 똥개가 태어난 순간부터는 내 키는 기록하지 않는 것. 즉, 새로운 옵저버블(시퀀스)이 생성되는 순간 이전 옵저버블이 방출하는 이벤트는 무시하는 것

<br>

## 3. Rx Networking

```swift
let response = Observable.just(booksUrlStr)
            .map { URL(string: $0)! }
            .map { URLRequest(url: $0) }
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map(BookList.parse(data:)) // parse(data:) : data를 받아 [Book] 배열로 반환하는 함수
            .asDriver(onErrorJustReturn: [])
```
- just연산자로 url 방출 -> URL
- URL -> URLRequest 객체로 변환
- RxCocoa에서 제공하는 URLSession Extension 중 data method는 파라미터로 URLRequest를 받음
```swift
    /*
    - parameter request: URL request.
    - returns: Observable sequence of response data.
    */
    public func data(request: URLRequest) -> Observable<Data> {
        return self.response(request: request).map { pair -> Data in
            if 200 ..< 300 ~= pair.0.statusCode {
                return pair.1
            }
            else {
                throw RxCocoaURLError.httpRequestFailed(response: pair.0, data: pair.1)
            }
        }
    }
```

- 최종적으로 bookUrlStr이라는 문자열을 방출하는 옵저버블이 Observable<Data>를 방출하는 옵저버블이 되게 된다.

<br>
<br>
