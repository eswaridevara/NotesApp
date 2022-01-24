//
//  RegistrationTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

protocol RegistrationDelete: AnyObject {
    func didTouchRegistration()
}

class RegistrationTableViewCell: UITableViewCell {
    
    static let identifier = "RegistrationTableViewCell"
    
    weak var delegate: RegistrationDelete?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchRegistration() {
        delegate?.didTouchRegistration()
    }
    
}
