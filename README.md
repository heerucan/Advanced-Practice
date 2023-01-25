# 🦄 반응형 프로그래밍 뽀개기 

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

## 4-1. Coordinator 정리
- [의존성주입, Coordinator 적용 정리](https://huree-can-do-it.notion.site/Coordinator-b649e56861d04fdd9ffbd47f5ec0a10b)


<br>
<br>

## 4-2. SSAC-Advanced-Project 정리 (a.k.a Unsplash Project)
### 1. Search 뷰

#### SearchViewModel

```swift
var userList = PublishSubject<SearchUser>()
    
    func requestSearchUser(query: String, page: Int) {
        PhotoAPIManager.shared.getSearchUser(query: query, page: page) { [weak self] (user, status, error) in
            guard let user = user,
                  let self = self else { return }
            self.userList.onNext(user)
        }
    }
```

1. 왜 Subject로 했는가?!?!?
- userlist에 서버통신할 때마다 새롭게 값을 넣어줄 수 있어야 하기 때문이다.
    
    즉, 옵저버의 역할도 가능해야 하니까! Subject로 해준 것이이다.
    
- 검색창에서 초반에 아무 것도 입력하지 않아서 보여줄 것이 없는 상태로 시작하기 때문에 **PublishSubject**

<br>


2. requestSearchUser() 내에서

- onNext를 통해서 이벤트를 꺼내서 쓴다!

<br>


#### SearchViewController

```swift
private func bindData() {
    
        // 1.
    searchViewModel.userList
        .withUnretained(self)
        .bind { (vc, user) in
        var snapshot = NSDiffableDataSourceSnapshot<Int, Result>()
        snapshot.appendSections([0])
        snapshot.appendItems(user.results)
        vc.dataSource.apply(snapshot, animatingDifferences: true)
    }
    .disposed(by: disposeBag)
    
        // 2. 
    searchView.searchBar.searchTextField.rx.text
        .orEmpty
        .debounce(.seconds(1), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .withUnretained(self)
        .subscribe { (vc, value) in
            vc.searchViewModel.requestSearchUser(query: value, page: 50)
        }
        .disposed(by: disposeBag)

        // 3.
    searchView.collectionView.rx.itemSelected
        .withUnretained(self)
        .subscribe(onNext: { (vc, item) in
            vc.pushDetailView(item)
            vc.searchView.collectionView.deselectItem(at: item, animated: true)
        })
        .disposed(by: disposeBag)
}
```

1. userList 내용을 → 데이터로 넣어줘!
    
    - 뷰컨의 디퍼블데이터소스를 통해서 어떤 데이터를 넣어줄 거냐? 할 때 
    
    - 뷰모델의 userList에서 SearchUser 모델의 데이터를 가져와서 데이터를 바인딩해준다.
    
    - 바인딩? → 뷰모델이 뷰컨한테 뷰의 데이터 변경을 알려주기 위해 사용
    
    📌 **bind를 써준 이유??**
    
    > 셀에 데이터를 넣어주는 부분이 ui를 그리는 측면이니까 complete/error 이벤트 처리할 필요 X
 
    

<br>


2.  검색하면 → 서버통신해줘!
    
    - searchTextField (옵저버블) → subscribe 내부 (옵저버)
    
    📌 **.debounce(.seconds(1), scheduler: MainScheduler.instance)**
    
    > 타이머를 지정해두고 타이머가 끝난 시점에 가장 최근의 값을 방출해준다.
    
    > 폭풍 검색을 하고 나서 마지막으로 사용자가 입력한 검색어에 한해 1초 후에 해당 검색어를 기준으로 1초 기다렸다가 서버통신
    
    📌 **distinctUntilChanged()**
    
    > 연달아 중복된 값이 올 때 무시
    
    > 즉, huree, ruhee, ruhee 검색 시에 ruhee라는 검색어는 결국 같으니까 이전 검색어와 같은 경우에는 무시

    📌 **subscribe를 쓴 이유?**
    
    > bind를 사용해도 괜찮음
    
    > searchBar에서 검색어를 입력해주는 것 자체는 UI적인 측면이니까 무한한 시퀀스에 해당함


<br>


3. 컬렉션뷰 셀 선택하면 → item 전달 + 화면전환해줘!
    
    📌 **subscribe를 쓴 이유?**
    
    > bind를 사용해도 괜찮음
    
    > 셀 선택 자체는 실패할 가능성이 없음
    
    > UI적인 측면에 해당하는 부분이라 무한한 시퀀스에 해당해서 bind로 바꿔도 가능

<br>


### 2. Detail 뷰

#### DetailViewModel

```swift
final class DetailViewModel {
    
    // MARK: - Get : User

    let userList = PublishSubject<User>()
    
    func requestUser(username: String) {
        PhotoAPIManager.shared.getUser(username: username) { [weak self] (user, status, error) in
            guard let user = user,
                  let self = self else { return }
            self.userList.onNext(user)
        }
    }
    
    // MARK: - Get : Photo
    
    let photoList = PublishSubject<[Photo]>()
    
    func requestUserPhoto(username: String) {
        PhotoAPIManager.shared.getUserPhoto(username: username) { [weak self] (photo, status, error) in
            guard let photo = photo,
                  let self = self else { return }
            self.photoList.onNext(photo)
        }
    }
}
```

1. userList / photoList
    - 위와 같은 맥락으로 초기값이 없어서 PublishSubject
    - 서버통신 후 새로운 값을 넣어줄 경우에 대응해야 하니까 옵저버블이자 옵저버인 Subject로 처리

<br>


#### DetailViewController

```swift
private func bindData() {

        detailViewModel.userList
            .withUnretained(self)
            .bind { (vc, data) in
                vc.detailView.setData(data: data)
            }
            .disposed(by: disposeBag)

        detailViewModel.photoList
            .withUnretained(self)
            .bind { (vc, photo) in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo)
            vc.dataSource.apply(snapshot)
        }
        .disposed(by: disposeBag)
        
        detailViewModel.requestUser(username: usernameId)
        detailViewModel.requestUserPhoto(username: usernameId)
    }
```
- 이벤트를 전달하는 객체 : 옵저버블 - viewmodel의 userList    
- 이벤트를 전달받는 객체 : 옵저버 - view의 userNameLabel, subLabel 등등    
- bind는 항상 Main에서 작동하니까 Main 큐 처리를 해주지 않아도 됨    



