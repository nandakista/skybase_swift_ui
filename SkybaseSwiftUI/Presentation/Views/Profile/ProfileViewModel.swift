//
//  ProfileViewModel.swift
//  LearSwift
//
//  Created by Nanda Kista Permana on 27/10/24.
//

import Foundation

class ProfileViewModel : BaseViewModel<GithubUser> {
    private let dataSource = GithubDataSource()
    private let authManager = AuthManager.shared
    
    override init() {
        /* TODO: Preview Mode
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
         self.allUsers.append(DeveloperPreview.instance.githubUser)
         })
         */
        super.init()
        onGetProfile()
    }
    
    func onGetProfile() {
        loadingState()
        dataSource.getUsersDetail(username: "nandakista")
            .sink(
                receiveCompletion: handleCompletion,
                receiveValue: { [weak self] user in
                    self?.loadFinish(data: user)
                }
            )
            .store(in: &cancellables)
    }
    
    func onLogout() {
        Task {
            await authManager.setUnauth()
        }
    }
}
