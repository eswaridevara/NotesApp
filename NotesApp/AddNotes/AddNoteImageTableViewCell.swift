//
//  AddNoteImageTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

protocol AddImageActionDelegate: AnyObject {
    func didTouchAddImage(_ sourceView: UIButton)
}

class AddNoteImageTableViewCell: UITableViewCell {
    
    static let identifier = "AddNoteImageTableViewCell"
    
    @IBOutlet weak var addImageButton: UIButton!
    
    weak var delegate: AddImageActionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addImageButton.layer.cornerRadius = 3.0
        addImageButton.layer.borderColor = UIColor.systemBlue.cgColor
        addImageButton.layer.borderWidth = 1.0
        addImageButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchAddImage() {
        delegate?.didTouchAddImage(addImageButton)
    }
    
}
