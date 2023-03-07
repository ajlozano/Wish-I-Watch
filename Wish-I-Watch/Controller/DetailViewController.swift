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
    
    let urlPrefix = "https://www.themoviedb.org"
    var detailUrl = ""
    
    var detailTitle: Title? {
        didSet {
            if let id = detailTitle?.tmdb_id {
                detailUrl = "\(urlPrefix)/\(detailTitle?.tmdb_type ?? "")/\(id)"
                print(detailUrl)
            }
        }
    }
    
    //var wishlistTitles = [SavedTitle]()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var wishlistTitlesManager = DataModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWebView()
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        if let detailTitleId = detailTitle?.tmdb_id {
            if let savedTitleIndex = wishlistTitlesManager.savedTitles.firstIndex(where: {$0.id == detailTitleId}) {
                //deleteWishlistTitle(indexTitle: savedTitleIndex)
                wishlistTitlesManager.deleteTitles(indexTitle: savedTitleIndex)
                sender.image = UIImage(systemName: "star")
            } else {
                //let savedTitle = SavedTitle(context: context.self)
                wishlistTitlesManager.savedTitle.id = Int32(detailTitle?.tmdb_id ?? 0)
                wishlistTitlesManager.savedTitle.imageUrl = detailTitle?.image_url
                wishlistTitlesManager.savedTitle.name = detailTitle?.name
                
                wishlistTitlesManager.savedTitles.append(wishlistTitlesManager.savedTitle)
                wishlistTitlesManager.saveTitles()
                //saveWishlistTitles()
                
                sender.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    func updateWebView() {
        let urlRequest = URLRequest(url: URL(string: detailUrl)!)
        webView.load(urlRequest)
    }
}
