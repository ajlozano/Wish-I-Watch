//
//  TitleManager.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    
    func fetchTitle(titleName: String, completion: @escaping ([Title]) -> ()) {
        let fixedTitleName = titleName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(Constants.URL.urlSearch)\(fixedTitleName)\(Constants.Endpoints.urlSearch)"
        print(urlString)
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error during data task session")
                return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Titles.self, from: safeData)
                    let titles = Titles(listOfTitles: decodedData.listOfTitles)
                    completion(titles.listOfTitles)
                } catch {
                    print(error)
                    return
                }
            }
        }
        task.resume()
    }
}
