//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Sergei Volotka on 27.07.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?

    func updateAvatar() {
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
    }
}
