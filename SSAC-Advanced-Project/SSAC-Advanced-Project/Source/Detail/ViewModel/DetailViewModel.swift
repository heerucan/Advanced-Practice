//
//  DetailViewModel.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/20.
//

import Foundation
import SwiftUI

final class DetailViewModel {
    
    lazy var user = User(id: "", username: "", profileImage: profileImage, totalPhotos: 0, photos: [photos])
    let profileImage = ProfileImage(large: "")
    let photos = Photo(urls: Urls(regular: ""))
    
    // MARK: - Get : User

    lazy var userList: CObservable<User> = CObservable(user)
    
    func requestUser(username: String) {
        PhotoAPIManager.shared.getUser(username: username) { [weak self] (user, status, error) in
            guard let user = user,
                  let self = self else { return }
            self.userList.value = user
        }
    }
    
    // MARK: - Get : Photo
    
    lazy var photoList: CObservable<[Photo]> = CObservable(user.photos)
    
    func requestUserPhoto(username: String) {
        PhotoAPIManager.shared.getUserPhoto(username: username) { [weak self] (photo, status, error) in
            guard let photo = photo,
                  let self = self else { return }
            self.photoList.value = photo
        }
    }
}
