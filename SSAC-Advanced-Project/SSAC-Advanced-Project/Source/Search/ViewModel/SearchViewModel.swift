//
//  SearchViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/24.
//

import Foundation

import RxSwift

final class SearchViewModel {
        
    var userList = PublishSubject<SearchUser>()
    
    func requestSearchUser(query: String, page: Int) {
        PhotoAPIManager.shared.getSearchUser(query: query, page: page) { [weak self] (user, status, error) in
            guard let user = user,
                  let self = self else { return }
            self.userList.onNext(user)
        }
    }
}
