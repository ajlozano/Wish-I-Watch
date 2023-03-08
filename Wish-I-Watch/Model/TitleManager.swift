//
//  TitleManager.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import Foundation
import UIKit

protocol TitleManagerDelegate {
    func didUpdateTitle(_ titleManager: TitleManager, _ titleResults: TitleAPIData)
    func didFailWithError(error: Error)
}

struct TitleManager {
    let titleSearchURL = "https://api.watchmode.com/v1/autocomplete-search/?apiKey="
    // TEST
    //let testImageURL = "https://es.wikipedia.org/wiki/Archivo:The.Matrix.glmatrix.2.png"
    
    var delegate: TitleManagerDelegate?
    
    func fetchTitle(titleName: String) {
        let fixedTitleName = titleName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(titleSearchURL)\(apiKey)&search_value=\(fixedTitleName)&search_type=2"
        print(urlString)
        performRequest(with: urlString)

        // TEST
//        let testTitleAPI = TitleAPIData(results: [
//            Results(name: "Avatar", year: 2010, image_url: testImageURL, tmdb_type: "Movie", tmdb_id: 1),
//            Results(name: "Matrix", year: 1999, image_url: testImageURL, tmdb_type: "Movie", tmdb_id: 2),
//            Results(name: "Die Hard", year: 1995, image_url: testImageURL, tmdb_type: "Movie", tmdb_id: 3)])
//        self.delegate?.didUpdateTitle(self, testTitleAPI)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let titles = self.parseJSON(safeData) {
                        self.delegate?.didUpdateTitle(self, titles)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ titleData: Data) -> TitleAPIData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TitleAPIData.self, from: titleData)
            
            let titles = TitleAPIData(results: decodedData.results)
            
            return titles
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
