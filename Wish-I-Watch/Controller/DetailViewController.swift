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
        
        dataModelManager.loadTitles()
 
        savedTitleIndex = findSavedTitle(id: detailTitle?.tmdb_id)
        if savedTitleIndex != nil {
            detailTitle?.isSaved = true
            saveButton.image = UIImage(systemName: "star.fill")
        }
        
        updateWebView()
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        if detailTitle?.isSaved == true {
            sender.image = UIImage(systemName: "star")
            
            detailTitle?.isSaved = false
            dataModelManager.deleteTitles(indexTitle: savedTitleIndex!)
        } else {
            sender.image = UIImage(systemName: "star.fill")
            detailTitle?.isSaved = false
            
            dataModelManager.setupItem(item: detailTitle!)
            dataModelManager.saveTitles()
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
