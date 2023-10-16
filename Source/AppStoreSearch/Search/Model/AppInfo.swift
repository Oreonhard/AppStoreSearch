//
//  AppList.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/17.
//

import Foundation

struct AppInfo: Decodable {
    let appTitle: String
    let appIcon: String
    let ageLimit: String
    let developer: String
    let description: String
    let releaseNotes: String?
    let currentReleaseDate: String?
    let version: String
    let starRating: Double
    let reviewCount: Double
    let previewImages: [String]
    let categories: [String]
    let languages: [String]
    
    enum CodingKeys: String, CodingKey {
        case appTitle = "trackName"
        case starRating = "averageUserRating"
        case reviewCount = "userRatingCount"
        case appIcon = "artworkUrl512"
        case previewImage = "screenshotUrls"
        case ageLimit = "contentAdvisoryRating"
        case categories = "genres"
        case languages = "languageCodesISO2A"
        case developer = "artistName"
        case currentReleaseDate = "currentVersionReleaseDate"
        case description
        case releaseNotes
        case version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        appTitle = try container.decode(String.self, forKey: .appTitle)
        starRating = try container.decode(Double.self, forKey: .starRating)
        reviewCount = try container.decode(Double.self, forKey: .reviewCount)
        appIcon = try container.decode(String.self, forKey: .appIcon)
        previewImages = try container.decode([String].self, forKey: .previewImage)
        ageLimit = try container.decode(String.self, forKey: .ageLimit)
        categories = try container.decode([String].self, forKey: .categories)
        languages = try container.decode([String].self, forKey: .languages)
        developer = try container.decode(String.self, forKey: .developer)
        description = try container.decode(String.self, forKey: .description)
        releaseNotes = try? container.decode(String.self, forKey: .releaseNotes)
        version = try container.decode(String.self, forKey: .version)
        currentReleaseDate = try? container.decode(String.self, forKey: .currentReleaseDate)
    }
}
