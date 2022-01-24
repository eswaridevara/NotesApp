//
//  LoginActionTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

protocol LoginActionDelegate: AnyObject {
    func didTouchLogin()
    func didTouchRegistration()
}

class LoginActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    static let identifier = "LoginActionTableViewCell"
    
    weak var delegate: LoginActionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func loginActionTouched() {
        delegate?.didTouchLogin()
    }
    
    @IBAction func registrationActionTouched() {
        delegate?.didTouchRegistration()
    }
}
