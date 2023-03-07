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
    let savedTitle: SavedTitle
    let context: NSManagedObjectContext
    
    init() {
        print("Data model init")
        savedTitles = [SavedTitle]()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        savedTitle = SavedTitle(context: self.context)
        loadTitles()
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
            print("Loading...")
        } catch {
            print("Error fetching context, \(error)")
        }
    }
    
    func deleteTitles(indexTitle: Int) {
       context.delete(savedTitles[indexTitle])
    }
}
