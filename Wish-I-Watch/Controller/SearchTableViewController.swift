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
    var titles = [Title]()
    var cell = SearchTitleTableViewCell()
    var selectedTitleIndex: Int = 0
    var dataModelManager = DataModelManager()
    
    var detailButtonIsPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataModelManager.loadTitles()
        
        titleManager.delegate = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SearchTitleTableViewCell
        cell.delegate = self
        
        //cell.titleImage.image = UIImage(systemName: "star")
        cell.titleLabel.text = titles[indexPath.row].name
        cell.titleLabel.numberOfLines = 0
        cell.yearLabel.text = "\(titles[indexPath.row].year)"
        cell.typeLabel.text = titles[indexPath.row].tmdb_type
        cell.titleId = titles[indexPath.row].tmdb_id
        
        if let data = titles[indexPath.row].imageData {
            cell.titleImage.image = UIImage(data: data)
        }

        if (titles[indexPath.row].isSaved) {
            cell.wishlistButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.wishlistButton.setImage(UIImage(systemName: "star"), for: .normal)
        }

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
                            
                            var isTitleSaved = false
                            if (self.findPersistentTitle(id: result.tmdb_id) != nil) {
                                isTitleSaved = true
                            }
          
                            self.titles.append(Title(name: result.name, year: yearString , image_url: result.image_url, tmdb_type: result.tmdb_type ?? "", tmdb_id: result.tmdb_id, imageData: data, isSaved: isTitleSaved))
                            
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
    
    func findPersistentTitle(id: Int?, isSavedTitle: Bool = true) -> Int? {
        if (isSavedTitle) {
            return dataModelManager.savedTitles.firstIndex(where: {$0.id == id!})
        } else {
            return dataModelManager.savedTitles.firstIndex(where: {$0.id == id!})
        }
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
        titles = []
        if let title = searchBar.text {
            titleManager.fetchTitle(titleName: title)
        }
    }
}

// MARK: - Title Cell delegate methods

extension SearchTableViewController: SearchTitleCellDelegate {
    func didSaveButtonPressed(_ titleId: Int) {
        if (checkSelectedTitle(titleId)) {
            if let wishlistIndex = dataModelManager.savedTitles.firstIndex(
                where: {$0.id == titles[self.selectedTitleIndex].tmdb_id}) {
                
                titles[self.selectedTitleIndex].isSaved = false

                dataModelManager.deleteTitles(indexTitle: wishlistIndex)
            } else {
                titles[self.selectedTitleIndex].isSaved = true

                dataModelManager.setupItem(item: titles[self.selectedTitleIndex])
                dataModelManager.saveTitles()
            }

            reloadTableViewData()
        } else {
            print("Failed selecting title index.")
        }
    }
    
    func didDetailButtonPressed(_ titleId: Int) {
        if (checkSelectedTitle(titleId)) {
            performSegue(withIdentifier: "goToDetailFromSearch", sender: self)
        } else {
            print("Failed selecting title index.")
        }
    }
    
    private func checkSelectedTitle(_ titleId: Int) -> Bool {
        if let searchIndex = titles.firstIndex(where: {$0.tmdb_id == titleId}) {
            selectedTitleIndex = searchIndex
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.detailTitle = titles[selectedTitleIndex]
        
        // Is necessary to unhide self tab bar before preparing detail tab bar
        self.tabBarController?.tabBar.isHidden = false
        destinationVC.tabBarItem.title = self.tabBarItem.title
        destinationVC.tabBarItem.image = self.tabBarItem.image
        
        if let viewedTitleIndex = findPersistentTitle(id: titles[selectedTitleIndex].tmdb_id, isSavedTitle: false) {
            dataModelManager.deleteTitles(indexTitle: viewedTitleIndex, isSavedItem: false)
        }
        
        dataModelManager.setupItem(item: titles[selectedTitleIndex], isSavedItem: false)
        dataModelManager.saveTitles()
    }
}



