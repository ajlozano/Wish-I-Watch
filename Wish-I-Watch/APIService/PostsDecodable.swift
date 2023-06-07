//
//  PostsCodable.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import Foundation

struct PostsDecodable: Codable {
    var listOfTitles: [Title]
    enum CodingKeys: String, CodingKey {
        case listOfTitles = "results"
    }
}
