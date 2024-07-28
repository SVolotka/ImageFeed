//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 16.07.2024.


import Foundation

final class ImagesListService {
    
    // MARK: - Public Properties
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
 
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if task != nil {
            print("[fetchPhotosNextPage]: ImagesListService - Recurring Request")
            return
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequest(page: nextPage) else {
            print("[fetchPhotosNextPage]: ImagesListService - Make Request")
            return
        }
            let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    data.forEach { photoResult in
                        if !self.photos.contains(where: { $0.id == photoResult.id }) {
                            self.photos.append(self.convertPhoto(photo: photoResult))
                        }
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["URL": self.photos])
                case .failure(let error):
                    print("[fetchPhotosNextPage]: ImagesListServiceError - Oшибка запроса \(error)")
                }
                self.task = nil
            }
            task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeChangeLikeRequest(photoId: photoId, isLike: !isLike) else {
            print("[changeLike]: ImagesListService - Make Request")
            return }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = data.photo.likedByUser
                }
                completion(.success(data.photo.likedByUser))
            case .failure(let error):
                print("[changeLike]: ImagesListServiceError - \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        task.resume()
    }
    
    func removePhotos() {
        photos = []
    }
    
    // MARK: - Private Methods
    private func makeRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)") else {
            print("[makeRequest]: ImagesListService - Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            print("[makeChangeLikeRequest]: ImagesListService - Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if isLike {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        return request
    }
    
    private func convertPhoto(photo: PhotoResult) -> Photo {
        let dateString = Formatter().convertDate(from: photo.createdAt)
        let newPhoto = Photo(
            id: photo.id,
            size: CGSize(width: photo.width, height: photo.height),
            createdAt: dateString,
            welcomeDescription: photo.description,
            thumbImageURL: photo.urls.regular,
            largeImageURL: photo.urls.full,
            isLiked: photo.likedByUser)
        return newPhoto
    }
}
