//
//  K.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 13/2/23.
//

import Foundation

struct K {
    static let titleName = "Wish I Watch"
    static let attribution = "Streaming data powered by Watchmode.com"
    static let starImage = "star"
    static let starFillImage = "star.fill"

    static let apiKey = "a5c94bb42a704c31de34273e1391f402"
    
    struct URL {
        static let mainApi = "https://api.themoviedb.org/"
        static let main = "https://www.themoviedb.org/"
        static let urlSearch = "https://api.themoviedb.org/3/search/movie?api_key=\(K.apiKey)&language=en-US&query="
        static let urlImages = "https://image.tmdb.org/t/p/w500/"
    }
    
    struct Endpoints {
        static let urlListPopularMovies = "3/movie/popular"
        static let urlDetailMovie = "movie/"
        static let urlSearch = "&page=1&include_adult=false"
    }
}


