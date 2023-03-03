//
//  SearchTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var titleManager = TitleManager()
    var titleFetchData = TitleAPIData(results: [])
    var titles = [Title]()
    var cell = TitleCell()
    var detailTitleIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        titleManager.delegate = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        


    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TitleCell
        cell.delegate = self
        //cell.titleImage.image = UIImage(named: "WishIWatchLogo")
        cell.titleLabel.text = titles[indexPath.row].name
        cell.titleLabel.numberOfLines = 0
        //cell.imageView?.image = nil
        if let data = titles[indexPath.row].imageData {
            cell.titleImage.image = UIImage(data: data)
        }
        cell.yearLabel.text = "\(titles[indexPath.row].year)"
        cell.typeLabel.text = titles[indexPath.row].tmdb_type
        
        return cell
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Title Manager delegate

extension SearchTableViewController: TitleManagerDelegate {
    func didUpdateTitle(_ titleManager: TitleManager, _ titleResults: TitleAPIData) {
        for index in 0 ..< titleResults.results.count {
            let result = titleResults.results[index]
            if (result.image_url != nil) {
                DispatchQueue.global().async {
                    // Fetch Image Data
                    if let data = try? Data(contentsOf: URL(string: result.image_url!)!) {
                        DispatchQueue.main.async {
                            var yearString = ""
                            if let year = result.year {
                                yearString = "\(year)"
                            }
                            
                            self.titles.append(Title(name: result.name, year: yearString , image_url: result.image_url, tmdb_type: result.tmdb_type ?? "",tmdb_id: result.tmdb_id, imageData: data))
                            if (index == titleResults.results.count - 1) {
                                self.reloadTableViewData()
                            }
                        }
                    } else {
                        print("Error Getting image from URL")
                    }
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - Search Bar delegate methods

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            titles = []
            reloadTableViewData()
            // Resign cursor in search
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let title = searchBar.text {
            print(titles.count)
            titleManager.fetchTitle(titleName: title)
        }
    }
}

// MARK: - Title Cell delegate methods

extension SearchTableViewController: TitleCellDelegate {
    func didDetailButtonPressed(_ titleLabel: UILabel) {
        if let index = titles.firstIndex(where: {$0.name == titleLabel.text!}) {
            detailTitleIndex = index
        }
        performSegue(withIdentifier: "goToDetailFromSearch", sender: self)
    }
    
    func didSaveButtonPressed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.detailTitle = titles[detailTitleIndex]
        // Is necessary to unhide self tab bar before preparing detail tab bar
        self.tabBarController?.tabBar.isHidden = false
        destinationVC.tabBarItem.title = self.tabBarItem.title
        destinationVC.tabBarItem.image = self.tabBarItem.image
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

