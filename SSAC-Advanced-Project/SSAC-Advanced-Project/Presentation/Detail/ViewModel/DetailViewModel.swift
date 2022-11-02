//
//  DetailViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import Foundation

import RxSwift

final class DetailViewModel: ViewModelType {

    let userList = PublishSubject<User>()
    let photoList = PublishSubject<[Photo]>()

    struct Input { }
    
    struct Output {
        let userList: PublishSubject<User>
        let photoList: PublishSubject<[Photo]>
    }
    
    func transform(input: Input) -> Output {
        let userList = userList
        let photoList = photoList
        return Output(userList: userList, photoList: photoList)
    }
    
    func requestUser(username: String) {
        PhotoAPIManager.shared.fetchData(.userProfile(username: username)) { [weak self] (result: Result<User, APIError>) in
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

    func requestUserPhoto(username: String) {
        PhotoAPIManager.shared.fetchData(.userPhotos(username: username)) { [weak self] (result: Result<[Photo], APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.photoList.onNext(value)
                
            case .failure(let error):
                self.photoList.onError(error)
                print(error.localizedDescription)
            }
        }
    }
}
