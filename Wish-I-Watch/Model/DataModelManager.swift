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
    let context: NSManagedObjectContext
    
    init() {
        savedTitles = [SavedTitle]()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        savingItem = nil
    }
    
    mutating func initItem() {
        savingItem = SavedTitle(context: self.context)
    }
    
    func saveTitles() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    mutating func loadTitles(with request: NSFetchRequest<SavedTitle> = SavedTitle.fetchRequest()) {
        do {
            savedTitles = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
    }
    
    mutating func deleteTitles(indexTitle: Int) {
        context.delete(savedTitles[indexTitle])
        savedTitles.remove(at: indexTitle)
        saveTitles()
    }
}
