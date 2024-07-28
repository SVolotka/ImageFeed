//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 23.07.2024.
//

import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func createObserver()
    func fetchPhotosNextPage()
    func changeLike(for cell: ImagesListCell, tableView: UITableView)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private var imagesListService = ImagesListService.shared
    
    init(view: ImagesListViewControllerProtocol
    ) {
        self.view = view
    }
    
    
    func viewDidLoad() {
        fetchPhotosNextPage()
        createObserver()
    }
    
    func createObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
    }
    
    func fetchPhotosNextPage(){
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(for cell: ImagesListCell, tableView: UITableView) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var photos = imagesListService.photos
        let photo = photos[indexPath.row] 
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let isLiked):
                photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked)
            case .failure(let error):
                print("[changeLike]: ImagesListViewControllerError - \(error)")
                view?.showChangeLikeErrorAlert()
            }
        }
    }
}
