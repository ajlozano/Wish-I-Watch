//
//  Item.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import Foundation

struct TitleData: Codable {
    var results: [Results]
}

struct Results: Codable {
    let name: String
    let year: Int?
    let image_url: String?
    let tmdb_type: String?
    let tmdb_id: Int
}


