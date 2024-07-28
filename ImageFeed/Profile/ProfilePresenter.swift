//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 23.07.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func createObserver()
    func logout()
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileService = ProfileService.shared
    private var profileLogoutService = ProfileLogoutService.shared
    
    init(view: ProfileViewControllerProtocol
    ) {
        self.view = view
    }
    
    func viewDidLoad() {
        guard let profile = profileService.profile else {
            return
        }
        view?.updateProfileDetails(profile: profile)
        createObserver()
        view?.updateAvatar()
    }
    
    func createObserver() {
        profileImageServiceObserver =
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil, queue: .main) { [weak self] _ in
                self?.view?.updateAvatar()
            }
    }
    
    func logout() {
        profileLogoutService.logout()
    }
}
