//
//  TitleCellTableViewCell.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 15/2/23.
//

import UIKit

protocol TitleCellDelegate {
    func didDetailButtonPressed(_ titleLabel: UILabel)
    func didSaveButtonPressed(_ titleLabel: UILabel)
}

class TitleCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: TitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleImage.layer.cornerRadius = 10
        
        //cellView.layer.cornerRadius = cellView.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("save button pressed, \(String(describing: titleLabel.text))")
        delegate?.didSaveButtonPressed(titleLabel)
    }
    @IBAction func detailsButtonPressed(_ sender: UIButton) {
        print("details button pressed, \(String(describing: titleLabel.text))")
        delegate?.didDetailButtonPressed(titleLabel)
    }
}
