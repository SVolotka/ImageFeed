//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 20.06.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuth2Token"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            return userDefaults.setValue(newValue, forKey: tokenKey)
        }
    }
}
