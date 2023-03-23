//
//  Title.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 15/2/23.
//

import UIKit

struct Title {
    let name: String
    let year: String
    let image_url: String?
    let tmdb_type: String
    let tmdb_id: Int
    var imageData: Data?
    var isSaved: Bool
}

struct Titles: Codable {
    var results: [Results]
}

struct Results: Codable {
    let name: String
    let year: Int?
    let imageUrl: String?
    let type: String?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case year
        case imageUrl = "image_url"
        case type = "tmdb_type"
        case id = "tmdb_id"
    }
}
