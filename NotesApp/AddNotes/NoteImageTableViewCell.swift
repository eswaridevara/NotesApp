//
//  NoteImageTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class NoteImageTableViewCell: UITableViewCell {
    
    static let identifier = "NoteImageTableViewCell"
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func prepareWith(_ field: NoteField) {
        noteTitleLabel.text = field.title
        noteImageView.image = field.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
