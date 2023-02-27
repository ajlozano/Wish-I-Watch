//
//  SearchTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var titleManager = TitleManager()
    
    var titleFetchData = TitleData(results: [])
    var titles = [Title]()
    var cell = TitleCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleManager.delegate = self
        
        //tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
//        titles = [
//            Title(name: "abscdsjsejsjesjssjssjaajssjsjs", year: "2002", image_url: "https://es.wikipedia.org/wiki/Avatar_(pel%C3%ADcula)#/media/Archivo:HuangShan.JPG", tmdb_type: "Movie", tmdb_id: 5),
//            Title(name: "Avatar 3", year: "2003", image_url: "https://es.wikipedia.org/wiki/Avatar_(pel%C3%ADcula)#/media/Archivo:HuangShan.JPG", tmdb_type: "Movie", tmdb_id: 5),
//            Title(name: "Avatar 4", year: "2004", image_url: "https://es.wikipedia.org/wiki/Avatar_(pel%C3%ADcula)#/media/Archivo:HuangShan.JPG", tmdb_type: "Movie", tmdb_id: 5),
//            Title(name: "Avatar 5", year: "2005", image_url: "https://es.wikipedia.org/wiki/Avatar_(pel%C3%ADcula)#/media/Archivo:HuangShan.JPG", tmdb_type: "Movie", tmdb_id: 5),
//            Title(name: "Avatar 6", year: "2006", image_url: "https://es.wikipedia.org/wiki/Avatar_(pel%C3%ADcula)#/media/Archivo:HuangShan.JPG", tmdb_type: "Movie", tmdb_id: 5),
//            Title(name: "Avatar 7", year: "2007", image_url: "https://es.wikipedia.org/wiki/Avatar_(pel%C3%ADcula)#/media/Archivo:HuangShan.JPG", tmdb_type: "Movie", tmdb_id: 5),
//        ]
        
        //reloadTableViewData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TitleCell
        //cell.titleImage.image = UIImage(named: "WishIWatchLogo")
        cell.titleLabel.text = titles[indexPath.row].name
        cell.titleLabel.numberOfLines = 0

        //cell.imageView?.image = nil
        if let data = titles[indexPath.row].imageData {
            cell.imageView?.image = UIImage(data: data)
            //cell.imageView?.sizeThatFits(CGSize(width: 10, height: 10))
            //cell.imageView?.image?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
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

// MARK: - TitleManagerDelegate

extension SearchTableViewController: TitleManagerDelegate {
    func didUpdateTitle(_ titleManager: TitleManager, _ titleResults: TitleData) {
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

extension SearchTableViewController: TitleCellDelegate {
    func didDetailButtonPressed() {
        
    }
    
    func didSaveButtonPressed() {
        
    }
}
