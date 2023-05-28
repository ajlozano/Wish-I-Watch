//
//  ContactsViewCell.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 28/5/23.
//

import UIKit

class ContactsViewCell: UITableViewCell {
    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var linkPath: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.backgroundColor = .clear
    }
    
    func setup(linkTitle: String, path: String) {
        linkLabel.text = linkTitle
        linkPath = path
    }
}
