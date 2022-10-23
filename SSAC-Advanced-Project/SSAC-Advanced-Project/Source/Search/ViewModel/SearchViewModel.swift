//
//  SearchViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/24.
//

import Foundation

final class SearchViewModel {
    
    var userList: CObservable<SearchUser> = CObservable(SearchUser(total: 0, totalPages: 0, results: []))
    
    func requestSearchUser(query: String) {
        PhotoAPIManager.shared.getSearchUser(query: query) { [weak self] (user, status, error) in
            guard let user = user,
                  let self = self else { return }
            self.userList.value = user
        }
    }
}
