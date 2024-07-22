//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Sergei Volotka on 16.07.2024.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
