//
//  HomeViewModel.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 29/3/23.
//

import Foundation

final class HomeViewModel {
    var viewedTitles: ObservableObject<[ViewedTitle]?> = ObservableObject(nil)
    
    func getViewedTitles() {
        DataPersistance.shared.loadTitles { savedTitles, viewedTitles in
            self.viewedTitles.value = viewedTitles
        }
    }
}
