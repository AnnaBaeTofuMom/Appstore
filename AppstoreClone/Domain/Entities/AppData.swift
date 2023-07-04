//
//  AppData.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import Foundation

struct AppData: Decodable {
    var trackId: Int?
    var trackName: String?
    let primaryGenreName: String
    var averageUserRating: String?
    var screenshotUrls: [String]?
    let artworkUrl100: String
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var version: String?
}
