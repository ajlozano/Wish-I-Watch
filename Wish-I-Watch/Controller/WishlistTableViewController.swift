//
//  WishlistTableViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit
import CoreData

class WishlistTableViewController: UIViewController {
    var wishlistData = DataModelManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedTitleIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.layer.cornerRadius = 10
        
        wishlistData.loadTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        wishlistData.loadTitles()
        collectionView.reloadData()
    }
}

extension WishlistTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistData.savedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistTitleCollectionViewCell", for: indexPath) as! WishlistTitleCollectionViewCell
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: self.wishlistData.savedTitles[indexPath.row].imageUrl!)!) {
                DispatchQueue.main.async {
                    cell.setup(image: UIImage(data: data)!,
                               name: self.wishlistData.savedTitles[indexPath.row].name!,
                               id: Int(self.wishlistData.savedTitles[indexPath.row].id))
                }
            }
        }
        
        return cell
    }
}

extension WishlistTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 245)
    }
}

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
                name: wishlistData.savedTitles[selectedTitleIndex].name!,
                year: wishlistData.savedTitles[selectedTitleIndex].year!,
                image_url: wishlistData.savedTitles[selectedTitleIndex].imageUrl,
                tmdb_type: wishlistData.savedTitles[selectedTitleIndex].type!,
                tmdb_id: Int(wishlistData.savedTitles[selectedTitleIndex].id),
                isSaved: wishlistData.savedTitles[selectedTitleIndex].isSaved)

            destinationVC.detailTitle = title
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
        }
    }
}


