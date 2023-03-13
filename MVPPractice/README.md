# MVP Practice

- MVP 패턴을 사용해 간단한 메모기능 구현
- 정리Link https://huree-can-do-it.notion.site/MVP-fbcdda731dff49f6aa900c7a6cf7bfe6

### troubleShooting

**1. ViewController에서 Presenter를 가져오기 위해서 의존성주입하기**
- Presenter의 인스턴스를 생성한 후에, 생성자에서 필요한 모든 종속성(여기서는 Presenter에게 Model 인스턴스를 생성해서 주입해야 한다)을 제공해야 한다. ("의존성 주입")
- 생성자를 통한 의존성 주입이 보편적이다. 이유는 인스턴스 생성 시점에 의존성 주입이 가능하기 때문에 코드의 의존성이 명확하게 나타나기 때문이다. 그래서 유지보수성이 높아진다.
    - 생성자 기반 의존성 주입을 하려면, SceneDelegate에서 해줘야 하려나?
- 내 경우, 프로퍼티를 통한 의존성 주입을 했다.

```
    private var presenter: MemoPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureLayout()
        configureDataSource()
        presenter = MemoPresenter(view: self, model: memoList)
    }
```

<br>

**2. 삭제기능 구현 시 발생한 문제**
- Flow : 사용자가 삭제버튼을 누르면  View -> Presenter의 deleteSelectedMemo(for:)에게 삭제한 indexPath를 전달하며 플로우가 시작된다.
```
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] action, view, completion in
                guard let self = self else { return }
                self.presenter.deleteSelectedMemo(for: indexPath)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
```
     
- 두 번째로, Presenter의 deleteSelectedMemo는 변경사항을 반영해 View에게 전달한다.
```
    func deleteSelectedMemo(for indexPath: IndexPath) {
        print("View가 Presenter에게 삭제가 일어났다고 알림")
        // MARK: - ?? 여기서 Presenter가 Model에게서 데이터 가져오는 부분이 없는데 몰까
        print("Presenter는 View에게 삭제한 indexPath 정보를 전달함")
        memoView?.deleteMemo(for: indexPath, memo: memoModel)
    }
```
     
- 마지막으로, View는 변경된 정보에 맞게 UI를 갱신한다.
```
    func deleteMemo(for indexPath: IndexPath, memo: Memo) {
        print("view가 presenter로부터 삭제 결과를 받았음---->>>", indexPath)
        if let deleteItem = dataSource.itemIdentifier(for: indexPath) {
            snapshot.deleteItems([deleteItem])
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
```
여기서 의문이었던 점은 2번에서 Presenter가 Model에서 데이터를 가져오는 부분이 없어서 맞게 패턴을 적용한 건지 의문이었던 것.      
답은, Presenter가 이미 Memo 모델을 가지고 있는 상황이다. 초반에 이니셜라이즈 부분에 Memo 인스턴스 의존성 주입을 한 것을 확인할 수 있다. 따라서, deleteSelectedMemo(for:)에서 Presenter는 이미 모델을 가지고 있기에 Model에서 데이터를 가져올 필요가 없는 것이다.      
Presenter는 View를 통해 전달받은 indexPath 정보를 가지고, Memo 모델에서 해당 indexPath를 삭제할 수 있다.
```
final class MemoPresenter: MemoPresenterProtocol {
    
    // MemoView 관련 인터페이스에 초기화 시 의존하는 것을 볼 수 있음
    weak var memoView: MemoViewProtocol?
    private var memoModel: Memo
    
    init(view: MemoViewProtocol, model: Memo) {
        self.memoView = view
        self.memoModel = model
    }
```

<br>

**3. apply()를 통해 스냅샷을 update하자!**
- View에서 Pesenter를 통해 모델을 가져와 UI를 갱신해줘야 한다면, 해당 코드를 꼭 작성해야 한다. DiffableDataSource에서는 performBatchesUpdate 대신 apply를 통해 스무스한 애니메이션을 제공하기 때문에 꼭 쓰자.

<br>

**4. DiffableDataSource에서 삭제를 하는 방법**
- deleteItems를 통해서 구현이 가능한데, 이때 나의 경우에는 해당 셀의 indexPath를 전달항 상황이기에 dataSource의 itemIdentifier에 접근하자
```
dataSource.itemIdentifier(for: indexPath)
```

<br>

### 새로운 사실
**1. reconfigureItems**
- iOS15부터 reconfigureItems이 reloadItems의 기능으로 새롭게 나왔다고 한다. 차이점은 reconfigureItems는 기존에 있는 셀을 재사용하는 거다. 기존 deque하고 새로 셀을 구성했던 것과 다르게. 그래서 좀 더 빠르다.
