//
//  LoginFieldTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class LoginFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fieldTitleLabel: UILabel!
    @IBOutlet weak var fieldTextField: UITextField!
    
    static let identifier = "LoginFieldTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func prepareWith(_ field: LoginField) {
        fieldTitleLabel.text = field.title
        fieldTextField.placeholder = "Enter \(field.title)"
        fieldTextField.text = field.value
        fieldTextField.isSecureTextEntry = field.type == .password || field.type == .confirmPassword
        fieldTextField.keyboardType = field.type == .email ? .emailAddress : field.type == .mobile ? .phonePad : .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
