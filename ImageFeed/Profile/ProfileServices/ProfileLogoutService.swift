//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 20.07.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()
    
    // MARK: - Private Properties
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Initializers
    private init() { }
    
    // MARK: - Public Methods
    func logout() {
        cleanCookies()
        
        oauth2TokenStorage.removeData()
        profileImageService.removeData()
        profileService.removeData()
        imagesListService.removePhotos()
    }
    
    // MARK: - Private Methods
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
