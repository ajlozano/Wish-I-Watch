//
//  Endpoints.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import Foundation

struct Endpoints {
    static let mainApiUrl = "https://api.themoviedb.org/"
    static let main = "https://www.themoviedb.org/"
    static let urlSearchHeader = "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.apiKey)&language=en-US&query="
    static let urlImages = "https://image.tmdb.org/t/p/w500/"
    
    static let urlListPopularMovies = "3/movie/popular"
    static let urlDetailMovie = "movie/"
    static let urlSearchFooter = "&page=1&include_adult=false"
}
