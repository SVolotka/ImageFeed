//
//  UserResult.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 04.07.2024.
//

import Foundation

struct UserResult: Decodable {
    let profileImage:ProfileImageSize?
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImageSize: Decodable {
    let small: String?
    let large: String?
}
