//
//  SearchViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/24.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    var userList = PublishSubject<SearchUser>()
    
    struct Input {
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let userList: PublishSubject<SearchUser>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let userList = userList
        let searchText = input.searchText
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        return Output(userList: userList, searchText: searchText)
    }
    
    func requestSearchUser(query: String, page: Int) {
        PhotoAPIManager.shared.fetchGenericData(.searchUser(query: query, page: page)) { [weak self] (result: Result<SearchUser, APIServiceError>) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.userList.onNext(value)
                
            case .failure(let error):
                self.userList.onError(error)
                print(error.localizedDescription)
            }
        }
    }
}
