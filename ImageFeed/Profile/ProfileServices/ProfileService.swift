//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 03.07.2024.


import Foundation

final class ProfileService {
    
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(with token: String,
                      completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastToken == token {
            completion(.failure(NetworkError.recurringRequest))
            print("[fetchProfile]: ProfileService - Recurring Request")
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard
            let request = makeRequest(token: token)
        else {
            print("[fetchProfile]: ProfileService - Make Request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[fetchProfile]: ProfileService - \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastToken = nil
        }
        self.task = task
        task.resume()
    }
    
    func removeData(){
        profile = nil
    }
    
    // MARK: - Private Methods
    private func makeRequest(token: String) -> URLRequest? {
        
        guard let url = URL(string: Constants.profileURL) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
