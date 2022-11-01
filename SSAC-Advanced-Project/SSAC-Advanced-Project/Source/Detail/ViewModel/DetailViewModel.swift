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

    struct Input {
        
    }
    
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
        PhotoAPIManager.shared.getUser(username: username) { [weak self] (user, status, error) in
            guard let user = user,
                  let self = self else { return }
            self.userList.onNext(user)
        }
    }
    
    func requestUserPhoto(username: String) {
        PhotoAPIManager.shared.getUserPhoto(username: username) { [weak self] (photo, status, error) in
            guard let photo = photo,
                  let self = self else { return }
            self.photoList.onNext(photo)
        }
    }
}
