//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Sergei Volotka on 27.07.2024.

@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var notificationCalled = false
    var didChangeLikeCalled = false
    var didFetchPhotosNextPageCalled = false
    var imagesListService: ImageFeed.ImagesListService
    
    init(imagesListService: ImagesListService){
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func createObserver() {
        notificationCalled = true
    }
    
    func fetchPhotosNextPage() {
        didFetchPhotosNextPageCalled = true
    }
    
    func changeLike(for cell: ImageFeed.ImagesListCell, tableView: UITableView) {
        didChangeLikeCalled = true
    }
}
