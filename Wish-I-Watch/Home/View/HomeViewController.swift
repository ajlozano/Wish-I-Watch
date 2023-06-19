//
//  HomeViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit
import ViewAnimator

class HomeViewController: UIViewController {

    private var dataPersistenceViewModel: DataPersistenceViewModel?
    var viewedTitles = [ViewedTitle]()
    var selectedTitleIndex: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataPersistenceViewModel = DataPersistenceViewModel()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //collectionView.layer.cornerRadius = 10

        setupBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        dataPersistenceViewModel?.getTitles()
        
        let animation = AnimationType.from(direction: .top, offset: 300)
        UIView.animate(views: collectionView.visibleCells, animations: [animation])
        
    }
    
    func setupBinders() {
        dataPersistenceViewModel?.viewedTitles.bind { viewedTitles in
            guard let titles = viewedTitles else {
                return
            }
            self.viewedTitles.removeAll()
            for title in titles {
                self.viewedTitles.append(title)
            }
            self.reloadCollectionViewData()
        }
    }
}

// MARK: - Collection view data source

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewedTitleCollectionViewCell", for: indexPath) as! ViewedTitleCollectionViewCell
        
        cell.setup(
            imageUrl: self.viewedTitles[indexPath.row].posterPath!,
            name: self.viewedTitles[indexPath.row].name!,
            id: Int((self.viewedTitles[indexPath.row].id)))
  
        return cell
    }
    
    func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Collection view delegate flow layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 180)
    }
}

// MARK: - Collection view delegate methods

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item")
        
        selectedTitleIndex = indexPath.item
        performSegue(withIdentifier: "goToDetailFromHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDetailFromHome") {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            
            let title = Title(
                id: Int(self.viewedTitles[selectedTitleIndex].id),
                name: self.viewedTitles[selectedTitleIndex].name!,
                overview: self.viewedTitles[selectedTitleIndex].overview!,
                date: self.viewedTitles[selectedTitleIndex].date!,
                posterPath: self.viewedTitles[selectedTitleIndex].posterPath,
                voteAverage: self.viewedTitles[selectedTitleIndex].voteAverage)
            destinationVC.detailTitle = title
        }
    }
}

