//
//  SearchDTO.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import Foundation

struct SearchDTO: Decodable {
    let resultCount: Int
    var results: [AppDataDTO]
}

struct AppDataDTO: Decodable {
    var trackId: Int?
    var trackName: String?
    let primaryGenreName: String
    var averageUserRating: Float?
    var screenshotUrls: [String]?
    let artworkUrl100: String
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var version: String?
}

extension SearchDTO {
    func toDomain() -> [AppData] {
        return self.results.map { $0.toDomain() }
        }
}

extension AppDataDTO {
    func toDomain() -> AppData {
        return AppData(trackId: self.trackId,
                       trackName: self.trackName,
                       primaryGenreName: self.primaryGenreName,
                       averageUserRating: String(format: "%.1f", self.averageUserRating!),
                       screenshotUrls: self.screenshotUrls,
                       artworkUrl100: self.artworkUrl100,
                       formattedPrice: self.formattedPrice,
                       description: self.description,
                       releaseNotes: self.releaseNotes,
                       artistName: self.artistName,
                       version: self.version)
    }
}
