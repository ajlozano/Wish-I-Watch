//
//  WishlistTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit
import CoreData

class WishlistTableViewController: UITableViewController {
    var dataModelManager = DataModelManager()
    
    var savedTitles = [SavedTitle]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        
        dataModelManager.loadSavedTitles()
        tableView.reloadData()
//        for title in wishlistTitlesManager.savedTitles {
//            print(title.name)
//        }
    }
    
    func loadTitles(with request: NSFetchRequest<SavedTitle> = SavedTitle.fetchRequest()) {
        do {
            savedTitles = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModelManager.savedTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath)

        cell.textLabel?.text = dataModelManager.savedTitles[indexPath.row].name
        
        return cell
    }

}

