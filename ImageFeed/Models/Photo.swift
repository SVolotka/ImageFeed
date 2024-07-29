//
//  Photo.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 16.07.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
