//
//  TitleManager.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import Foundation

protocol TitleManagerDelegate {
    func didUpdateTitle(_ titleManager: TitleManager, _ titles: Title)
    func didFailWithError(error: Error)
}

struct TitleManager {
    let titleURL = "https://api.watchmode.com/v1/autocomplete-search/?apiKey="
    
    var delegate: TitleManagerDelegate?
    
    func fetchTitle(titleName: String) {
        let urlString = "\(titleURL)\(apiKey)&search_value=\(titleName)&search_type=2"
        print(urlString)
        performRequest(with: urlString)
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
    
    func parseJSON(_ titleData: Data) -> Title? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Title.self, from: titleData)
            
            let titles = Title(results: decodedData.results)
            
            return titles
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
