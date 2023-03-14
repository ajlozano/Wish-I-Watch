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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedTitleIndex: Int = 0
    
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
        
        dataModelManager.loadTitles()
        
        let animation = AnimationType.from(direction: .top, offset: 300)
        UIView.animate(views: collectionView.visibleCells, animations: [animation])
        
        collectionView.reloadData()
    }
}

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
                name: dataModelManager.savedTitles[selectedTitleIndex].name!,
                year: dataModelManager.savedTitles[selectedTitleIndex].year!,
                image_url: dataModelManager.savedTitles[selectedTitleIndex].imageUrl,
                tmdb_type: dataModelManager.savedTitles[selectedTitleIndex].type!,
                tmdb_id: Int(dataModelManager.savedTitles[selectedTitleIndex].id),
                isSaved: dataModelManager.savedTitles[selectedTitleIndex].isSaved)

            destinationVC.detailTitle = title

            if let viewedTitleIndex = findPersistentTitle(id: title.tmdb_id, isSavedTitle: false) {
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
    
    func findPersistentTitle(id: Int?, isSavedTitle: Bool = true) -> Int? {
        if (isSavedTitle) {
            return dataModelManager.savedTitles.firstIndex(where: {$0.id == id!})
        } else {
            return dataModelManager.viewedTitles.firstIndex(where: {$0.id == id!})
        }
    }
}


