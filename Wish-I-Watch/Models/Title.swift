//
//  Item.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import Foundation

struct Title: Codable {
    var results: [Results]
}

struct Results: Codable {
    let id: Int
    let name: String
    let year: Int
    let image_url: String?
    let tmdb_type: String
}
