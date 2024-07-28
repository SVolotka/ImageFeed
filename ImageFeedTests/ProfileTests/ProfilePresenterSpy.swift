//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Sergei Volotka on 27.07.2024.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationCalled: Bool = false
    var logoutCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func createObserver() {
        notificationCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
}
