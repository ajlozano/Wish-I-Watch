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

    var detailUrl = ""
    
    private let dataPersistenceViewModel = DataPersistenceViewModel()
    var wishlistTitles = [WishlistTitle]()
    
    var detailTitle: Title? {
        didSet {
            if let id = detailTitle?.id {
                detailUrl = "\(K.URL.main)\(K.Endpoints.urlDetailMovie)\(id)"
                print(detailUrl)
            }
        }
    }
    var savedTitleIndex: Int?
    var viewAppearedBefore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinders()
        updateWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewAppearedBefore  {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            viewAppearedBefore = true
        }
 
        dataPersistenceViewModel.getTitles()
    }
    
    func setupBinders() {
        dataPersistenceViewModel.wishlistTitles.bind { wishlistTitles in
            guard let titles = wishlistTitles else {
                print("Error getting savedTitles from persistent data.")
                return
            }
            self.wishlistTitles.removeAll()
            for title in titles {
                self.wishlistTitles.append(title)
            }
            
            if (wishlistTitles?.firstIndex(where: { $0.id == self.detailTitle!.id}) != nil) {
                self.saveButton.image = UIImage(systemName: "star.fill")
            } else {
                self.saveButton.image = UIImage(systemName: "star")
            }
        }
    }

    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        dataPersistenceViewModel.replacePersistentTitle(title: detailTitle!)
    }
    
    func updateWebView() {
        let urlRequest = URLRequest(url: URL(string: detailUrl)!)
        webView.load(urlRequest)
    }
}
