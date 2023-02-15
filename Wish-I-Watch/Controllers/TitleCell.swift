//
//  TitleCellTableViewCell.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 15/2/23.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
