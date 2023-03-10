//
//  HomeViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit

class HomeViewController: UIViewController {

    var recentlyViewedData = DataModelManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedTitleIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.layer.cornerRadius = 10
        
        recentlyViewedData.loadTitles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        recentlyViewedData.loadTitles()
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentlyViewedData.viewedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewedTitleCollectionViewCell", for: indexPath) as! ViewedTitleCollectionViewCell
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: self.recentlyViewedData.viewedTitles[indexPath.row].imageUrl!)!) {
                DispatchQueue.main.async {
                    cell.setup(image: UIImage(data: data)!,
                               name: self.recentlyViewedData.viewedTitles[indexPath.row].name!,
                               id: Int(self.recentlyViewedData.viewedTitles[indexPath.row].id))
                }
            }
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item")
        
        selectedTitleIndex = indexPath.item
        performSegue(withIdentifier: "goToDetailFromHome", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDetailFromHome") {
            let destinationVC = segue.destination as! DetailViewController
            let title = Title(
                name: recentlyViewedData.viewedTitles[selectedTitleIndex].name!,
                year: recentlyViewedData.viewedTitles[selectedTitleIndex].year!,
                image_url: recentlyViewedData.viewedTitles[selectedTitleIndex].imageUrl,
                tmdb_type: recentlyViewedData.viewedTitles[selectedTitleIndex].type!,
                tmdb_id: Int(recentlyViewedData.viewedTitles[selectedTitleIndex].id),
                isSaved: recentlyViewedData.viewedTitles[selectedTitleIndex].isSaved)

            destinationVC.detailTitle = title
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
        }
    }
}

