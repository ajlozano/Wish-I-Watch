//
//  DetailViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 27/2/23.
//

import UIKit
import WebKit
import CoreData

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let urlPrefix = "https://www.themoviedb.org"
    var detailUrl = ""
    var dataModelManager = DataModelManager()
    var detailTitle: Title? {
        didSet {
            if let id = detailTitle?.tmdb_id {
                detailUrl = "\(urlPrefix)/\(detailTitle?.tmdb_type ?? "")/\(id)"
                print(detailUrl)
            }
        }
    }
    var savedTitleIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModelManager.loadSavedTitles()
 
        savedTitleIndex = findSavedTitle(id: detailTitle?.tmdb_id)
        if savedTitleIndex != nil {
            detailTitle?.isSaved = true
            saveButton.image = UIImage(systemName: "star.fill")
        }
        
        updateWebView()
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        if detailTitle?.isSaved == true {
            detailTitle?.isSaved = false
            dataModelManager.deleteTitles(indexTitle: savedTitleIndex!, isSavedType: true, title: dataModelManager.savedTitles[savedTitleIndex!])
            
            sender.image = UIImage(systemName: "star")
        } else {
            detailTitle?.isSaved = false
            dataModelManager.initSavingItem()
            dataModelManager.savingItem!.id = Int32(detailTitle?.tmdb_id ?? 0)
            dataModelManager.savingItem!.imageUrl = detailTitle?.image_url
            dataModelManager.savingItem!.name = detailTitle?.name

            dataModelManager.savedTitles.append(dataModelManager.savingItem!)
            dataModelManager.saveTitles()

            sender.image = UIImage(systemName: "star.fill")
        }
    }
    
    func findSavedTitle(id: Int?) -> Int? {
        return dataModelManager.savedTitles.firstIndex(where: {$0.id == id!})
    }
    
    func updateWebView() {
        let urlRequest = URLRequest(url: URL(string: detailUrl)!)
        webView.load(urlRequest)
    }
}
