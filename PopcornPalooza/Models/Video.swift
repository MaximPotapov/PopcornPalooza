//
//  Video.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 15.10.2023.
//

import Foundation

struct VideoResult: Decodable {
    let id: Int
    let results: [Video]

    enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}

struct Video: Decodable {
    let iso6391: String
    let iso31661: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let videoId: String

    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case videoId = "id"
    }
}
