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
    var viewAppearedBefore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewAppearedBefore  {
            if let mainVC = self.navigationController?.viewControllers[0] {
                self.navigationController?.popToViewController(mainVC, animated: true)
            }
        } else {
            viewAppearedBefore = true
        }
        
        dataModelManager.loadTitles()
 
        savedTitleIndex = dataModelManager.findPersistentTitle(id: detailTitle?.tmdb_id)
        if savedTitleIndex != nil {
            detailTitle?.isSaved = true
            saveButton.image = UIImage(systemName: "star.fill")
        }
    }

    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        if dataModelManager.findPersistentTitle(id: detailTitle?.tmdb_id) != nil {
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
    
    func updateWebView() {
        let urlRequest = URLRequest(url: URL(string: detailUrl)!)
        webView.load(urlRequest)
    }
}
