//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    static let identifier = "NotesTableViewCell"
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        noteTitleLabel.text = nil
        noteDescriptionLabel.text = nil
        noteImageView.image = nil
    }
    
    func prepareWith(_ note: Note) {
        noteTitleLabel.text = note.title
        noteDescriptionLabel.text = note.description
        noteImageView.image = note.images?.first
        
        if let images = note.images, !images.isEmpty {
            noteImageView.image = images.first
        } else {
            noteImageView.image = UIImage(named: "no-note-image")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
