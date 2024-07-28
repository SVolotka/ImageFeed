//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Sergei Volotka on 23.07.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad(){
        //Given
        let imagesListService = ImagesListService.shared
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.viewDidLoad()
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsObserver() {
        //Given
        let imagesListService = ImagesListService.shared
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.createObserver()
        
        //Then
        XCTAssertTrue(presenter.notificationCalled)
    }
    
    func testFetchPhotos() {
        //Given
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImagesListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //When
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        //Then
        XCTAssertTrue(presenter.didFetchPhotosNextPageCalled)
    }
    
    func testViewControllerCallsUpdateTableView() {
        // given
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let viewController = ImagesListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(viewController.updateTableCalled)
    }
}
