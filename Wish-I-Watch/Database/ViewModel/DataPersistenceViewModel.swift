//
//  DataPersistanceViewModel.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 30/3/23.
//

import Foundation
import CoreData

final class DataPersistenceViewModel {
    var wishlistTitles: ObservableObject<[WishlistTitle]?> = ObservableObject(nil)
    var viewedTitles: ObservableObject<[ViewedTitle]?> = ObservableObject(nil)
    
    var dataPersistence: DataPersistence?
    
    init() {
        dataPersistence = DataPersistence()
    }
    
    func getTitles() {
        dataPersistence!.loadTitles { wishlistTitles, viewedTitles in
            if let wishlist = self.wishlistTitles.value {
                if (wishlistTitles.elementsEqual(wishlist) == false) {
                    self.wishlistTitles.value = wishlistTitles
                }
            } else {
                self.wishlistTitles.value = wishlistTitles
            }

            if let viewed = self.viewedTitles.value {
                if (viewedTitles.elementsEqual(viewed) == false) {
                    self.viewedTitles.value = viewedTitles
                }
            } else {
                self.viewedTitles.value = viewedTitles
            }
        }
    }
    
    func saveTitle(title: Title, isWishlistTitle: Bool = true) {
        dataPersistence!.setupItem(item: title, isWishlistItem: isWishlistTitle)
        save()
    }
    
    func deleteTitle(indexTitle: Int, isWishlistTitle: Bool = true) {
        dataPersistence!.deleteTitles(indexTitle: indexTitle, isWishlistTitle: isWishlistTitle)
        save()
    }
   
    func replacePersistentTitle(title: Title, isWishlistTitle: Bool = true) {
        if (isWishlistTitle) {
            if let wishlistIndex = wishlistTitles.value?.firstIndex(where: {$0.id == title.id}) {
                deleteTitle(indexTitle: wishlistIndex)
            } else {
                saveTitle(title: title)
            }
        } else {
            if let viewedIndex = viewedTitles.value?.firstIndex(where: {$0.id == title.id}) {
                deleteTitle(indexTitle: viewedIndex, isWishlistTitle: false)
            }
            saveTitle(title: title, isWishlistTitle: false)
        }
    }
    
    func deleteAllWishlistTitles() {
        dataPersistence!.deleteAllData()
    }
    
    private func save() {
        dataPersistence!.saveTitles { wishlistTitles, viewedTitles in
            self.wishlistTitles.value = wishlistTitles
            self.viewedTitles.value = viewedTitles
        }
    }
}
