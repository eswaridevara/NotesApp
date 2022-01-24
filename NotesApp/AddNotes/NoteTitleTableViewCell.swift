//
//  NoteTitleTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class NoteTitleTableViewCell: UITableViewCell {
    
    static let identifier = "NoteTitleTableViewCell"
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteValueTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func prepareWith(_ field: NoteField, shouldEdit: Bool) {
        noteTitleLabel.text = field.title
        noteValueTextView.text = field.value
        noteValueTextView.isEditable = shouldEdit
        if shouldEdit {
            noteValueTextView.layer.cornerRadius = 3.0
            noteValueTextView.layer.borderColor = UIColor.lightGray.cgColor
            noteValueTextView.layer.borderWidth = 1.0
            noteValueTextView.layer.masksToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
