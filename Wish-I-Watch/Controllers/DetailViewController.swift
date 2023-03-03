//
//  DetailViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 27/2/23.
//

import UIKit
import WebKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWebView()
        
        
    }
    
    func updateWebView() {
        let urlRequest = URLRequest(url: URL(string: detailUrl)!)
        webView.load(urlRequest)
    }
}
