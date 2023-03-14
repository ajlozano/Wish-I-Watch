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
    var dataModelManager = DataModelManager()
    var selectedTitleIndex: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.layer.cornerRadius = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        let animation = AnimationType.from(direction: .top, offset: 300)
        UIView.animate(views: collectionView.visibleCells, animations: [animation])
        
        dataModelManager.loadTitles()
        
        collectionView.reloadData()
    }
}

// MARK: - Collection view data source

extension WishlistTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModelManager.savedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistTitleCollectionViewCell", for: indexPath) as! WishlistTitleCollectionViewCell
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: self.dataModelManager.savedTitles[indexPath.row].imageUrl!)!) {
                DispatchQueue.main.async {
                    cell.setup(image: UIImage(data: data)!,
                               name: self.dataModelManager.savedTitles[indexPath.row].name!,
                               id: Int(self.dataModelManager.savedTitles[indexPath.row].id))
                }
            }
        }
        
        return cell
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
                name: dataModelManager.savedTitles[selectedTitleIndex].name!,
                year: dataModelManager.savedTitles[selectedTitleIndex].year!,
                image_url: dataModelManager.savedTitles[selectedTitleIndex].imageUrl,
                tmdb_type: dataModelManager.savedTitles[selectedTitleIndex].type!,
                tmdb_id: Int(dataModelManager.savedTitles[selectedTitleIndex].id),
                isSaved: dataModelManager.savedTitles[selectedTitleIndex].isSaved)

            destinationVC.detailTitle = title

            if let viewedTitleIndex = dataModelManager.findPersistentTitle(id: title.tmdb_id, isSavedTitle: false) {
                dataModelManager.deleteTitles(indexTitle: viewedTitleIndex, isSavedItem: false)
            }
            dataModelManager.setupItem(item: title, isSavedItem: false)
            dataModelManager.saveTitles()
            
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
        }
    }
}


