//
//  SearchTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var titleManager = TitleManager()
    
    var titleResults = Title(results: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleManager.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleResults.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)

        cell.textLabel?.text = titleResults.results[indexPath.row].name

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
    func didUpdateTitle(_ titleManager: TitleManager, _ titles: Title) {
        //titleResults = titles
        //tableView.reloadData()
        print(titles)
        titleResults.results = []

        for result in titles.results {
            titleResults.results.append(result)
        }
      
        reloadTableViewData()

    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - Search Bar delegate methods

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            titleResults.results = []
            reloadTableViewData()
            // Resign cursor in search
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let title = searchBar.text {
            titleManager.fetchTitle(titleName: title)
        }
    }
}
