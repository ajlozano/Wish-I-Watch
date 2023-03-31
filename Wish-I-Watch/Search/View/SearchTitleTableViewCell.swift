//
//  TitleCellTableViewCell.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 15/2/23.
//

import UIKit

protocol SearchTitleCellDelegate {
    func didDetailButtonPressed(_ titleId: Int)
    func didSaveButtonPressed(_ titleId: Int)
}

class SearchTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wishlistButton: UIButton!
    var titleId: Int = 0
    
    var delegate: SearchTitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleImage.layer.cornerRadius = 10
        
        wishlistButton.setImage(UIImage(systemName: "star"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.didSaveButtonPressed(titleId)
    }
    @IBAction func detailsButtonPressed(_ sender: UIButton) {
        delegate?.didDetailButtonPressed(titleId)
    }
    
}
