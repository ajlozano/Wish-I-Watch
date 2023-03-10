//
//  DataModelManager.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 7/3/23.
//

import UIKit
import CoreData

struct DataModelManager {
    var savedTitles: [SavedTitle]
    var savingItem: SavedTitle?
    
    var viewedTitles: [ViewedTitle]
    var viewedItem: ViewedTitle?

    let context: NSManagedObjectContext
    
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        savedTitles = [SavedTitle]()
        viewedTitles = [ViewedTitle]()
        savingItem = nil
        viewedItem = nil
    }
    
    mutating func setupItem(item: Title, isSavedItem: Bool = true) {
        if (isSavedItem) {
            savingItem = SavedTitle(context: self.context)
            
            savingItem?.id = Int32(item.tmdb_id)
            savingItem?.name = item.name
            savingItem?.imageUrl = item.image_url
            savingItem?.type = item.tmdb_type
            savingItem?.year = item.year
            savingItem?.isSaved = item.isSaved
            
            savedTitles.append(savingItem!)
        } else {
            viewedItem = ViewedTitle(context: self.context)
            
            viewedItem?.id = Int32(item.tmdb_id)
            viewedItem?.name = item.name
            viewedItem?.imageUrl = item.image_url
            viewedItem?.type = item.tmdb_type
            viewedItem?.year = item.year
            viewedItem?.isSaved = item.isSaved
            
            viewedTitles.append(viewedItem!)
            
            if (viewedTitles.count > 10) {
                deleteTitles(indexTitle: 0, isSavedItem: false)
            }
        }
    }

    func saveTitles() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    mutating func loadTitles(with savedRequest: NSFetchRequest<SavedTitle> = SavedTitle.fetchRequest(),
                             with viewedRequest: NSFetchRequest<ViewedTitle> = ViewedTitle.fetchRequest()) {
        do {
            savedTitles = try context.fetch(savedRequest)
        } catch {
            print("Error fetching savedTitles context, \(error)")
        }
        
        do {
            viewedTitles = try context.fetch(viewedRequest)
        } catch {
            print("Error fetching viewedTitles context, \(error)")
        }
    }
    
    mutating func deleteTitles(indexTitle: Int, isSavedItem: Bool = true) {
        if (isSavedItem) {
            context.delete(savedTitles[indexTitle])
            savedTitles.remove(at: indexTitle)
        } else {
            context.delete(viewedTitles[indexTitle])
            viewedTitles.remove(at: indexTitle)
        }
        saveTitles()
    }
}
