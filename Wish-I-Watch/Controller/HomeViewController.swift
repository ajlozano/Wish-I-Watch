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
    var selectedTitleIndex: Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //collectionView.layer.cornerRadius = 10
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModelManager.viewedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewedTitleCollectionViewCell", for: indexPath) as! ViewedTitleCollectionViewCell
        
        cell.setup(
            imageUrl: self.dataModelManager.viewedTitles[indexPath.row].posterPath!,
            name: self.dataModelManager.viewedTitles[indexPath.row].name!,
            id: Int(self.dataModelManager.viewedTitles[indexPath.row].id))
  
        return cell
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
            let title = Title(
                id: Int(dataModelManager.viewedTitles[selectedTitleIndex].id),
                name: dataModelManager.viewedTitles[selectedTitleIndex].name!,
                overview: dataModelManager.viewedTitles[selectedTitleIndex].overview!,
                date: dataModelManager.viewedTitles[selectedTitleIndex].date!,
                posterPath: dataModelManager.viewedTitles[selectedTitleIndex].posterPath,
                voteAverage: dataModelManager.viewedTitles[selectedTitleIndex].voteAverage)
            destinationVC.detailTitle = title
            // Is necessary to unhide self tab bar before preparing detail tab bar
            self.tabBarController?.tabBar.isHidden = false
            destinationVC.tabBarItem.title = self.tabBarItem.title
            destinationVC.tabBarItem.image = self.tabBarItem.image
        }
    }
}

