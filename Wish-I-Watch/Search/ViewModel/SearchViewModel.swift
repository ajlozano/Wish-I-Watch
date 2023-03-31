//
//  SearchViewModel.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 29/3/23.
//

import Foundation

final class SearchViewModel {
    var titles: ObservableObject<[Title]?> = ObservableObject(nil)
 
    func fetchTitle(titleName: String) {
        NetworkService.shared.fetchTitle(titleName: titleName) { [weak self] titles in
            var items = titles
            for i in 0..<items.count {
                let newString = items[i].date.replacingOccurrences(of: "-", with: "/")
                items[i].date = newString
            }
            self?.titles.value = items
        }
    }
}
