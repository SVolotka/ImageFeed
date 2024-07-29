//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 16.07.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct PhotoLikeResult: Decodable {
    let photo: PhotoResult
}

