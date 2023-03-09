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
    
    mutating func initSavingItem() {
        savingItem = SavedTitle(context: self.context)
    }
    
    mutating func initViewedItem() {
        viewedItem = ViewedTitle(context: self.context)
    }
    
    func saveTitles() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    mutating func loadSavedTitles(with request: NSFetchRequest<SavedTitle> = SavedTitle.fetchRequest()) {
        do {
            savedTitles = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
    }
    
    mutating func loadViewedTitles(with request: NSFetchRequest<ViewedTitle> = ViewedTitle.fetchRequest()) {
        do {
            viewedTitles = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
    }
    
    mutating func deleteTitles(indexTitle: Int, isSavedType: Bool, title: NSManagedObject) {
        context.delete(title)
        if (isSavedType) {
            savedTitles.remove(at: indexTitle)
        } else {
            viewedTitles.remove(at: indexTitle)
        }

        saveTitles()
    }
}
