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
    let name: String
    let image_url: String?
}
