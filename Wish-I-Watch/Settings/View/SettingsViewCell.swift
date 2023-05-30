//
//  SettingsViewCell.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 28/5/23.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    
    let relativeFontConstant: CGFloat = 0.036
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.backgroundColor = .clear
    }
    
    func setup(icon: UIImage ,title: String, action: UIView, screenWidth: CGFloat) {
        iconImage.image = icon
        titleLabel.font = titleLabel.font.withSize(screenWidth * relativeFontConstant)
        titleLabel.text = title
        actionView.addSubview(action)
    }
}
