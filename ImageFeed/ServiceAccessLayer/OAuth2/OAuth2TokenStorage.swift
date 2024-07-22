//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 20.06.2024.

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: "OAuth2Token")
        }
        set {
            guard let token = newValue else { return }
            keychainWrapper.set(token, forKey: "OAuth2Token")
        }
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    func removeData() {
        keychainWrapper.remove(forKey: "OAuth2Token")
    }
}
