//
//  Title.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 15/2/23.
//

import Foundation

struct Titles: Codable {
    var listOfTitles: [Title]
    enum CodingKeys: String, CodingKey {
        case listOfTitles = "results"
    }
}

struct Title: Codable {
    let id: Int
    let name: String
    let overview: String
    var date: String
    let posterPath: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case overview
        case date = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
