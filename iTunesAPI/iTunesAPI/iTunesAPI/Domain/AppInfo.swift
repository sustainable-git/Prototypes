//
//  AppInfo.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import Foundation

struct Applications: Codable {
    let count: Int
    let apps: [App]
    
    enum CodingKeys: String, CodingKey {
        case count = "resultCount"
        case apps = "results"
    }
}

struct App: Codable {
    let thumbnailURL: String
    let title: String
    let price: String
    let rating: Double
    let details: String
    let screenShotURLs: [String]
    
    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "artworkUrl512"
        case title = "trackName"
        case price = "formattedPrice"
        case rating = "averageUserRating"
        case details = "description"
        case screenShotURLs = "screenshotUrls"
    }
}
