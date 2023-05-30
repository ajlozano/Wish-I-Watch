//
//  WishlistTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit
import CoreData
import ViewAnimator

class WishlistTableViewController: UIViewController {
    
    private let dataPersistenceViewModel = DataPersistenceViewModel()
    var wishlistTitles = [WishlistTitle]()

    var selectedTitleIndex: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.layer.cornerRadius = 10

        setupBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false

        dataPersistenceViewModel.getTitles()
        
        let animation = AnimationType.from(direction: .top, offset: 300)
        UIView.animate(views: collectionView.visibleCells, animations: [animation])
    }
    
    func setupBinders() {
        dataPersistenceViewModel.wishlistTitles.bind { wishlistTitles in
            guard let titles = wishlistTitles else {
                return
            }
            self.wishlistTitles.removeAll()
            for title in titles {
                self.wishlistTitles.append(title)
            }
            
            self.reloadCollectionViewData()
        }
    }
}

// MARK: - Collection view data source

extension WishlistTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistTitleCollectionViewCell", for: indexPath) as! WishlistTitleCollectionViewCell

        cell.setup(imageUrl: self.wishlistTitles[indexPath.row].posterPath!,
                   name: self.wishlistTitles[indexPath.row].name!,
                   id: Int(self.wishlistTitles[indexPath.row].id))

        return cell
    }
    
    func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Collection view Delegate Flow Layout

extension WishlistTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 245)
    }
}

// MARK: - Collection view Delegate methods

extension WishlistTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item")
        
        selectedTitleIndex = indexPath.item
        performSegue(withIdentifier: "goToDetailFromWishlist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDetailFromWishlist") {
            let destinationVC = segue.destination as! DetailViewController
            let title = Title(
                id: Int(wishlistTitles[selectedTitleIndex].id),
                name: wishlistTitles[selectedTitleIndex].name!,
                overview: wishlistTitles[selectedTitleIndex].overview!,
                date: wishlistTitles[selectedTitleIndex].date!,
                posterPath: wishlistTitles[selectedTitleIndex].posterPath,
                voteAverage: wishlistTitles[selectedTitleIndex].voteAverage)
            destinationVC.detailTitle = title

            dataPersistenceViewModel.replacePersistentTitle(title: destinationVC.detailTitle!, isWishlistTitle: false)
            
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
        }
    }
}


