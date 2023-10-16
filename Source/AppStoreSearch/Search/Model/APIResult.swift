//
//  APIResult.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/17.
//

import Foundation

struct APIResult: Decodable {
    let resultCount: Int
    let appLists: [AppInfo]
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case appLists = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resultCount = try container.decode(Int.self, forKey: .resultCount)
        appLists = try container.decode([AppInfo].self, forKey: .appLists)
    }
}
