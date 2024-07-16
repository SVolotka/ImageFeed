//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 04.07.2024.

import Foundation

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfileImageURL(username: String, authToken: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard
            let request = makeRequest(username: username, token: authToken)
        else {
            print("[fetchProfileImageURL]: ProfileImageService - Make Request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                if let profileImage = userResult.profileImage {
                    guard let profileImageURL = profileImage.large else { return }
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": profileImageURL])
                }
            case .failure(let error):
                print("[fetchProfileImageURL]: ProfileImageService - \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeRequest(username: String, token: String) -> URLRequest? {
        guard
            let url = URL(string: "https://api.unsplash.com/users/\(username)")
        else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
