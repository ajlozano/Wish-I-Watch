//
//  ViewedTitleCell.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 9/3/23.
//

import UIKit

class ViewedTitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    var titleId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleImage.layer.cornerRadius = 10
        titleImage.layer.borderColor = UIColor.systemYellow.cgColor
        titleImage.layer.borderWidth = 1
    }
    
    func setup(image: UIImage, name: String, id: Int) {
        titleLabel.text = name
        titleImage.image = image
        titleId = id
    }
}