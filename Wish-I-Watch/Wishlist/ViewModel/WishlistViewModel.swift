//
//  WishlistViewModel.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 29/3/23.
//

import Foundation

final class WishlistViewModel {
    var wishlistTitles: ObservableObject<[SavedTitle]?> = ObservableObject(nil)
    
    func getWishlistTitles() {
        DataPersistance.shared.loadTitles { wishlistTitles, viewedTitles in
            self.wishlistTitles.value = savedTitles
        }
    }
}
