//
//  HomeViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit

class HomeViewController: UIViewController {

    var storedData = DataModelManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        storedData.loadViewedTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedData.viewedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewedTitleCollectionViewCell", for: indexPath) as! ViewedTitleCollectionViewCell
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: self.storedData.viewedTitles[indexPath.row].imageUrl!)!) {
                DispatchQueue.main.async {
                    cell.setup(image: UIImage(data: data)!,
                               name: self.storedData.viewedTitles[indexPath.row].name!,
                               id: Int(self.storedData.viewedTitles[indexPath.row].id))
                }
            }
            
        }
        
        return cell
    }
}

