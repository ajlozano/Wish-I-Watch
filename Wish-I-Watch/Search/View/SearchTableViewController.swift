//
//  SearchTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit

class SearchTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    private let searchViewModel = SearchViewModel()
    private let dataPersistenceViewModel = DataPersistenceViewModel()
    var titles = [Title]()
    var wishlistTitles = [SavedTitle]()
    var viewedTitles = [ViewedTitle]()

    var selectedTitleIndex: Int = 0
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        
        setupActivityIndicator()
        
        setupBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        dataPersistenceViewModel.getTitles()
    }
    
    func setupBinders() {
        searchViewModel.titles.bind { [weak self] titles in
            guard let titleList = titles else {
                print("There is no list of titles!")
                return
            }
            self?.titles = titleList
            self?.turnActivityIndicator(state: false)
            self?.reloadTableViewData()
        }
        
        dataPersistenceViewModel.viewedTitles.bind { viewedTitles in
            guard let titles = viewedTitles else {
                print("Error getting viewedTitles from persistent data.")
                return
            }
            self.viewedTitles.removeAll()
            for title in titles {
                self.viewedTitles.append(title)
            }
        }
        
        dataPersistenceViewModel.wishlistTitles.bind { savedTitles in
            guard let titles = savedTitles else {
                print("Error getting savedTitles from persistent data.")
                return
            }
            self.wishlistTitles.removeAll()
            for title in titles {
                self.wishlistTitles.append(title)
            }
            self.reloadTableViewData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SearchTitleTableViewCell
        cell.delegate = self
        cell.titleLabel.text = titles[indexPath.row].name
        
        cell.dateLabel.text = "\(titles[indexPath.row].date)"
        cell.overviewLabel.text = titles[indexPath.row].overview
        cell.titleId = titles[indexPath.row].id
        if (titles[indexPath.row].posterPath == nil) {
            cell.titleImage.imageFromServerUrl(imageUrl: nil,
                                               placeHolderImage: UIImage(named: "MovieImage")!)
        } else {
            cell.titleImage.imageFromServerUrl(imageUrl: "\(K.URL.urlImages+titles[indexPath.row].posterPath!)",
                                               placeHolderImage: UIImage(named: "MovieImage")!)
        }
        
        if (wishlistTitles.firstIndex(where: { $0.id == titles[indexPath.row].id}) != nil) {
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
        if let text = searchBar.text {
            turnActivityIndicator(state: true)
            searchViewModel.fetchTitle(titleName: text)
        }
    }
}

// MARK: - Title Cell delegate methods

extension SearchTableViewController: SearchTitleCellDelegate {
    func didSaveButtonPressed(_ titleId: Int) {
        if (checkSelectedTitle(titleId)) {
            if let wishlistIndex = wishlistTitles.firstIndex(where: { $0.id == titleId}) {
                dataPersistenceViewModel.deleteTitle(indexTitle: wishlistIndex)
            } else {
                dataPersistenceViewModel.saveTitle(title: titles[self.selectedTitleIndex])
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
        // Is necessary to unhide self tab bar before preparing detail tab bar
        self.tabBarController?.tabBar.isHidden = false
        destinationVC.tabBarItem.title = self.tabBarItem.title
        destinationVC.tabBarItem.image = self.tabBarItem.image
        
        destinationVC.detailTitle = titles[selectedTitleIndex]
        
        dataPersistenceViewModel.replacePersistentTitle(title: destinationVC.detailTitle!, isWishlistTitle: false)
    }
}

// MARK: - Activity indicator methods

extension SearchTableViewController {
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
}



