//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 20.06.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    private init() { }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else { fatalError() }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                           
        ) else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code)  else {
            completion(.failure(URLError(.badURL)))
            print("Invalid request")
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = tokenResponse.accessToken
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode OAuth token")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch OAuth token")
            }
        }
        task.resume()
    }
}
