//
//  HomeViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 14/2/23.
//

import UIKit
import ViewAnimator

class HomeViewController: UIViewController {

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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModelManager.viewedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewedTitleCollectionViewCell", for: indexPath) as! ViewedTitleCollectionViewCell
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: self.dataModelManager.viewedTitles[indexPath.row].imageUrl!)!) {
                DispatchQueue.main.async {
                    
                    cell.setup(image: UIImage(data: data)!,
                               name: self.dataModelManager.viewedTitles[indexPath.row].name!,
                               id: Int(self.dataModelManager.viewedTitles[indexPath.row].id))
                }
            }
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 180)
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
                name: dataModelManager.viewedTitles[selectedTitleIndex].name!,
                year: dataModelManager.viewedTitles[selectedTitleIndex].year!,
                image_url: dataModelManager.viewedTitles[selectedTitleIndex].imageUrl,
                tmdb_type: dataModelManager.viewedTitles[selectedTitleIndex].type!,
                tmdb_id: Int(dataModelManager.viewedTitles[selectedTitleIndex].id),
                isSaved: dataModelManager.viewedTitles[selectedTitleIndex].isSaved)

            destinationVC.detailTitle = title
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
        }
    }
}

