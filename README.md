# 🦄 반응형 프로그래밍 뽀개기 

## 1. SSAC-Advanced-Project (a.k.a Unsplash Project)
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

---

<br>

## 2. RxPractice

- [1. Observable과 Observer](https://roniruny.tistory.com/266)
- [2. Share()를 통한 구독 공유](https://roniruny.tistory.com/267)
- [3. Scheduler](https://roniruny.tistory.com/268)
- [4. Error Handling - catch, catchAndReturn, retry](https://roniruny.tistory.com/269)
- [5. RxCocoa (feat. TableView, CollectionView)](https://roniruny.tistory.com/270)
- [6. Binder](https://roniruny.tistory.com/271)
- [7. Traits - ControlProperty, ControlEvent, Driver](https://roniruny.tistory.com/272)

#### Rx Operator 시리즈
- [1. map](https://roniruny.tistory.com/273)
- [2. combineLatest](https://roniruny.tistory.com/274)
- [3. zip](https://roniruny.tistory.com/275)
