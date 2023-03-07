//
//  MemoPresenter.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/03.
//

import Foundation

/*
 Presenter는 View와 Model을 중재하는 역할, 각각의 인터페이스를 가지고 있고, 그로 인해 의존성이 생김
 완벽한 분리, 독립은 불가능
 */

final class MemoPresenter: MemoPresenterProtocol {
    
    // MemoView 관련 인터페이스에 초기화 시 의존하는 것을 볼 수 있음
    weak var memoView: MemoViewProtocol?
    private var memoModel: Memo
    
    init(view: MemoViewProtocol, model: Memo) {
        self.memoView = view
        self.memoModel = model
    }
    
    // MARK: - Protocol Method
    
    // 모델에서 메모를 추가/삭제할 때 Presenter를 거쳐 View에게 알리게 된다.
    // View에서는 Presenter를 거쳐 Model에 변경사항을 알리게 된다.
    func addButtonClicked(with memo: Memo) {
        print("4. Presenter 코드 내에서 -> Model에게 새로운 메모가 추가하도록 알림 - memoModel.addMemo")
        memoModel.addMemo(memo)
        print("5. Presenter 코드 내에서 -> View에게 변경된 데이터를 응답 - memoView.addMemo")
        memoView?.addMemo(memo: memo)
    }
    
    func deleteSelectedMemo(for indexPath: IndexPath) {
        print("View가 Presenter에게 삭제가 일어났다고 알림")
        // MARK: - ?? 여기서 Presenter가 Model에게서 데이터 가져오는 부분이 없는데 몰까
        print("Presenter는 View에게 삭제한 indexPath 정보를 전달함")
        memoView?.deleteMemo(for: indexPath, memo: memoModel)
    }
}
