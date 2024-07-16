//
//  Constants.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 13.06.2024.
//

import UIKit

enum Constants{
    static let accessKey = "cGDCgiZT9xqLwR0Pu0sqeYmjvKmOXGlEOOuSd7WY6m8";
    static let secretKey = "NVU7MtqnLPjhvjUETqSW7yN0t_7oXkVqZeaJfFJWy50";
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    
    static let profileURL = "https://api.unsplash.com/me"
    static let authorizeURL = "https://unsplash.com/oauth/authorize"
}
