//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Sergei Volotka on 23.07.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
       
        //When
        _ = viewController.view
      
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsLogout() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
       
        //When
        presenter.logout()
      
        //Then
        XCTAssertTrue(presenter.logoutCalled)
    }
    
    func testViewControllerCallsObserver() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.createObserver()
       
        //Then
        XCTAssertTrue(presenter.notificationCalled)
    }
}
