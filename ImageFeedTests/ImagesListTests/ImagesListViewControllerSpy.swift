//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Sergei Volotka on 27.07.2024.
//

import UIKit
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    func showChangeLikeErrorAlert() {
    }
    
    var updateTableCalled = false
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var photos: [ImageFeed.Photo]
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func updateTableViewAnimated() {
        updateTableCalled = true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosNextPage()
    }
}
