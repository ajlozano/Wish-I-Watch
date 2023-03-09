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
    var wishlistTitlesManager = DataModelManager()
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
        
        wishlistTitlesManager.loadSavedTitles()
 
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
            wishlistTitlesManager.deleteTitles(indexTitle: savedTitleIndex!, isSavedType: true, title: wishlistTitlesManager.savedTitles[savedTitleIndex!])
            
            sender.image = UIImage(systemName: "star")
        } else {
            detailTitle?.isSaved = false
            wishlistTitlesManager.initSavingItem()
            wishlistTitlesManager.savingItem!.id = Int32(detailTitle?.tmdb_id ?? 0)
            wishlistTitlesManager.savingItem!.imageUrl = detailTitle?.image_url
            wishlistTitlesManager.savingItem!.name = detailTitle?.name

            wishlistTitlesManager.savedTitles.append(wishlistTitlesManager.savingItem!)
            wishlistTitlesManager.saveTitles()

            sender.image = UIImage(systemName: "star.fill")
        }
    }
    
    func findSavedTitle(id: Int?) -> Int? {
        return wishlistTitlesManager.savedTitles.firstIndex(where: {$0.id == id!})
    }
    
    func updateWebView() {
        let urlRequest = URLRequest(url: URL(string: detailUrl)!)
        webView.load(urlRequest)
    }
}
