//
//  TitleManager.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import Foundation

protocol TitleManagerDelegate {
    func didUpdateTitle(_ titleManager: TitleManager, _ titleResults: Titles)
    func didFailWithError(error: Error)
}

struct TitleManager {
    var delegate: TitleManagerDelegate?
    
    func fetchTitle(titleName: String) {
        let fixedTitleName = titleName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(K.URL.urlSearch)\(fixedTitleName)\(K.Endpoints.urlSearch)"
        print(urlString)
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Titles.self, from: safeData)
                    var titles = Titles(listOfTitles: decodedData.listOfTitles)
                    titles.listOfTitles.removeAll(where: { $0.posterPath == nil})
                    self.delegate?.didUpdateTitle(self, titles)
                } catch {
                    delegate?.didFailWithError(error: error)
                    return
                }
            }
        }
        task.resume()
    }
}
