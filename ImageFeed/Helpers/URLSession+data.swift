//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 20.06.2024.

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case recurringRequest
    case decodingError
    case differentCodes
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[data]: URLSession+data - Status Code")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[data]: URLSession+data - URL Request Error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[data]: URLSession+data - URL Session Error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        return task
    }
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    fulfillCompletionOnTheMainThread(.success(result))
                } catch {
                    print("[URLSession.data]: Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    fulfillCompletionOnTheMainThread(.failure(error))
                }
            case .failure(let error):
                print("[objectTask]: URLSession+data - URL Session Error Ошибка \(error)")
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        return task
    }
}
