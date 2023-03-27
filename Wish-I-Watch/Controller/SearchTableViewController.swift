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
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleManager.delegate = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        
        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        dataModelManager.loadTitles()
        reloadTableViewData()
    }
    
    func setupActivityIndicator() {
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        loadingView.isHidden = true
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.style = .large
        spinner.color = .white

        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        self.tableView.addSubview(loadingView)
    }
    
    func turnActivityIndicator(state: Bool) {
        DispatchQueue.main.async {
            if (state) {
                self.loadingView.isHidden = false
                self.loadingLabel.isHidden = false
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
                self.loadingLabel.isHidden = true
                self.loadingView.isHidden = true
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SearchTitleTableViewCell
        cell.delegate = self
        cell.titleLabel.text = titles[indexPath.row].name
        cell.titleLabel.numberOfLines = 0
        
        cell.dateLabel.text = "\(titles[indexPath.row].date)"
        cell.overviewLabel.text = titles[indexPath.row].overview
        cell.titleId = titles[indexPath.row].id
        cell.titleImage.imageFromServerUrl(imageUrl: "\(K.URL.urlImages+titles[indexPath.row].posterPath!)",
                                           placeHolderImage: UIImage(named: "MovieImage")!)
        if (dataModelManager.findPersistentTitle(id: titles[indexPath.row].id) != nil) {
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
    func didUpdateTitle(_ titleManager: TitleManager, _ titleResults: Titles) {
        self.turnActivityIndicator(state: false)
        for result in titleResults.listOfTitles {
            self.titles.append(result)
        }
        self.reloadTableViewData()
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
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        titles = []
        if let title = searchBar.text {
            turnActivityIndicator(state: true)
            titleManager.fetchTitle(titleName: title)
        }
    }
}

// MARK: - Title Cell delegate methods

extension SearchTableViewController: SearchTitleCellDelegate {
    func didSaveButtonPressed(_ titleId: Int) {
        if (checkSelectedTitle(titleId)) {
            if let wishlistIndex = dataModelManager.findPersistentTitle(id: titleId) {
                dataModelManager.deleteTitles(indexTitle: wishlistIndex)
            } else {
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
        if let searchIndex = titles.firstIndex(where: {$0.id == titleId}) {
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
        
        if let viewedTitleIndex = dataModelManager.findPersistentTitle(id: titles[selectedTitleIndex].id, isSavedTitle: false) {
            dataModelManager.deleteTitles(indexTitle: viewedTitleIndex, isSavedItem: false)
        }
        
        dataModelManager.setupItem(item: titles[selectedTitleIndex], isSavedItem: false)
        dataModelManager.saveTitles()
    }
}



