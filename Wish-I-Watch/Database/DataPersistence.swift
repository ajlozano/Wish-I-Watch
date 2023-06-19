//
//  DataModelManager.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 7/3/23.
//

import UIKit
import CoreData

class DataPersistence {
    var wishlistTitles = [WishlistTitle]()
    var viewedTitles = [ViewedTitle]()

    let context: NSManagedObjectContext
    
    // Used for production
    static var shared = DataPersistence()
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.context = container.viewContext
        //self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate unavailable")
        }
        
        self.init(container: appDelegate.persistentContainer)
    }
    
    func loadTitles(with savedRequest: NSFetchRequest<WishlistTitle> = WishlistTitle.fetchRequest(),
                             with viewedRequest: NSFetchRequest<ViewedTitle> = ViewedTitle.fetchRequest(),
                             completion: ([WishlistTitle], [ViewedTitle]) -> ()) {
        let wishlistList: [WishlistTitle]
        let viewedList: [ViewedTitle]
        do {
            wishlistList = try context.fetch(savedRequest)
        } catch {
            print("Error fetching savedTitles context, \(error)")
            return
        }
        
        do {
            viewedList = try context.fetch(viewedRequest)
        } catch {
            print("Error fetching viewedTitles context, \(error)")
            return
        }
        self.wishlistTitles = wishlistList
        self.viewedTitles = viewedList
        
        completion(wishlistList, viewedList)
    }
    
    func setupItem(item: Title, isWishlistItem: Bool = true) {
        if (isWishlistItem) {
            let wishlistItem = WishlistTitle(context: self.context)
            
            wishlistItem.id = Int32(item.id)
            wishlistItem.name = item.name
            wishlistItem.posterPath = item.posterPath
            wishlistItem.overview = item.overview
            wishlistItem.date = item.date
            wishlistItem.voteAverage = item.voteAverage!
            wishlistTitles.append(wishlistItem)
        } else {
            let viewedItem = ViewedTitle(context: self.context)
            
            viewedItem.id = Int32(item.id)
            viewedItem.name = item.name
            viewedItem.posterPath = item.posterPath
            viewedItem.overview = item.overview
            viewedItem.date = item.date
            viewedItem.voteAverage = item.voteAverage!
            
            viewedTitles.append(viewedItem)
            
            if (viewedTitles.count > 10) {
                deleteTitles(indexTitle: 0, isWishlistTitle: false)
            }
        }
    }
    
    func saveTitles(completion: ([WishlistTitle], [ViewedTitle]) -> ()) {
        do {
            try context.save()
            completion(wishlistTitles, viewedTitles)
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func deleteTitles(indexTitle: Int, isWishlistTitle: Bool = true) {
        if (isWishlistTitle) {
            print("Data persistence count: \(wishlistTitles.count)")
            context.delete(wishlistTitles[indexTitle])
            wishlistTitles.remove(at: indexTitle)
        } else {
            context.delete(viewedTitles[indexTitle])
            viewedTitles.remove(at: indexTitle)
        }

        saveTitles { _, _ in }
    }
    
    func findPersistentTitle(id: Int?, isWishlistTitle: Bool = true) -> Int?
    {
        if (isWishlistTitle) {
            return wishlistTitles.firstIndex(where: {$0.id == id!})
        } else {
            return viewedTitles.firstIndex(where: {$0.id == id!})
        }
    }
    
    func deleteAllData() {
        for data in wishlistTitles {
            context.delete(data)
            saveTitles { _, _ in }
        }
        wishlistTitles.removeAll()
    }
}
