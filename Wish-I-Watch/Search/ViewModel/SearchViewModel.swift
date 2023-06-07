//
//  SearchViewModel.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 29/3/23.
//

import Foundation

final class SearchViewModel {
    var titles: ObservableObject<[Title]?> = ObservableObject(nil)
 
    // Dependencies
    private let fetchPostsRepository: FetchPostsRepository?
    
    var error: Error?
    
    init(fetchPostsRepository: FetchPostsRepository = DefaultFetchPostsRepository()) {
        self.fetchPostsRepository = fetchPostsRepository
    }
    
    func fetchTitle(titleName: String) {
        let fixedTitleName = titleName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(Endpoints.urlSearchHeader)\(fixedTitleName)\(Endpoints.urlSearchFooter)"
        print(urlString)
        
        Task {
            do {
                guard let decodable = try await fetchPostsRepository?.fetchPosts(url: urlString) else {
                    self.error = AppError.unExpectedError
                    return
                }
                
                var items = decodable.listOfTitles
                for i in 0..<decodable.listOfTitles.count {
                    let newString = items[i].date.replacingOccurrences(of: "-", with: "/")
                    items[i].date = newString
                }
                self.titles.value = items
            } catch {
                self.error = error
            }
        }
    }
}
