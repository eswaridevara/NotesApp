//
//  AddNotesViewController.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit
import Toast_Swift

class AddNotesViewController: UIViewController {
    
    static func create() -> AddNotesViewController? {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesViewController") as? AddNotesViewController
    }
    
    @IBOutlet weak var notesTableView: UITableView!
    
    private var fields = [NoteField]()
    private var imagePicker: ImagePicker?
    private var user: User?
    var selectedNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFields()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = DataManager.shared.getSignedInUser()
        
        if selectedNote == nil {
            self.title = "Add Notes"
            let saveButtonItem = UIBarButtonItem(title: "Save Note", style: .done, target: self, action: #selector(saveNote))
            self.navigationItem.rightBarButtonItem = saveButtonItem
        } else {
            self.title = "Note Details"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    private func configureFields() {
        if selectedNote == nil {
            fields = [
                NoteField(type: .title, title: "Title", value: nil, image: nil),
                NoteField(type: .description, title: "Description", value: nil, image: nil),
                NoteField(type: .addImage, title: "Add Image", value: nil, image: nil)
            ]
        } else if let note = selectedNote {
            fields = [
                NoteField(type: .title, title: "Title", value: note.title, image: nil),
                NoteField(type: .description, title: "Description", value: note.description, image: nil)
            ]
            
            if let images = note.images, !images.isEmpty {
                for image in images {
                    let field = NoteField(type: .image, title: nil, value: nil, image: image)
                    fields.append(field)
                }
            }
        }
        
    }
    
    private func configureTableView() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        notesTableView.register(UINib(nibName: NoteTitleTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoteTitleTableViewCell.identifier)
        notesTableView.register(UINib(nibName: NoteImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoteImageTableViewCell.identifier)
        notesTableView.register(UINib(nibName: AddNoteImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AddNoteImageTableViewCell.identifier)
        
        notesTableView.separatorStyle = .none
        notesTableView.tableFooterView = UIView()
    }
    
    @objc func saveNote() {
        notesTableView.endEditing(true)
        guard let user = user else { return }
        var note = Note(noteId: DataManager.shared.getNoteUniqueId(), userId: user.id)
        if let noteTitle = fields.first(where: { $0.type == .title })?.value?.trimmingCharacters(in: .whitespacesAndNewlines), !noteTitle.isEmpty {
            note.title = noteTitle
        } else {
            self.view.makeToast("Please add notes title")
            return
        }
        
        if let noteDescription = fields.first(where: { $0.type == .description })?.value?.trimmingCharacters(in: .whitespacesAndNewlines), !noteDescription.isEmpty {
            note.description = noteDescription
        } else {
            self.view.makeToast("Please add notes description")
            return
        }
        
        var images = [UIImage]()
        let imageFields = fields.filter({ $0.type == .image })
        images = imageFields.compactMap({ $0.image })
        note.images = images
        
        DataManager.shared.saveNote(note)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getCellidentifierFor(_ type: NoteFieldTypeEnum) -> String {
        switch type {
        case .image:
            return NoteImageTableViewCell.identifier
        case .addImage:
            return AddNoteImageTableViewCell.identifier
        default:
            return NoteTitleTableViewCell.identifier
        }
    }

}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension AddNotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < fields.count else { return UITableViewCell() }
        let field = fields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellidentifierFor(field.type), for: indexPath)
        if indexPath.row < fields.count, let noteCell = cell as? NoteTitleTableViewCell {
            noteCell.prepareWith(field, shouldEdit: selectedNote == nil)
            noteCell.noteValueTextView.tag = indexPath.row
            noteCell.noteValueTextView.delegate = self
        } else if let imageCell = cell as? NoteImageTableViewCell {
            imageCell.prepareWith(field)
        } else if let addImageCell = cell as? AddNoteImageTableViewCell {
            addImageCell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < fields.count else { return 0 }
        let fieldType = fields[indexPath.row].type
        switch fieldType {
        case .addImage:
            return 150
        case .image:
            return 260
        case .title:
            if let title = selectedNote?.title, !title.isEmpty {
                let height = title.height(withConstrainedWidth: tableView.bounds.width - 40, font: UIFont.systemFont(ofSize: 14)) + 60
                return height
            }
            return 80
        case .description:
            if let description = selectedNote?.description, !description.isEmpty {
                let height = description.height(withConstrainedWidth: tableView.bounds.width - 40, font: UIFont.systemFont(ofSize: 14)) + 60
                return height
            }
            return 300
        }
    }
}

extension AddNotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        /// Handle if needed
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var existingText = textView.text ?? ""
        if !text.isEmpty {
            existingText = existingText + text
        } else {
            existingText = String(existingText.dropLast())
        }
        
        if textView.tag == 0 {
            return existingText.count <= 100 /// Allow max: 100 for note title
        }
        return existingText.count <= 500 /// Allow max: 500 for note description
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let fieldindex = textView.tag
        fields[fieldindex].update(value: textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fieldindex = textView.tag
        fields[fieldindex].update(value: textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

// MARK:- AddImageActionDelegate
extension AddNotesViewController: AddImageActionDelegate {
    func didTouchAddImage(_ sourceView: UIButton) {
        imagePicker?.present(from: sourceView)
    }
}

// MARK:- ImagePickerDelegate
extension AddNotesViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        let field = NoteField(type: .image, title: nil, value: nil, image: image)
        let index = 2 /// Allways add new image on top
        fields.insert(field, at: index)
        if fields.count == 13 { /// if images limit reached to 10 hide the add image option
            fields.removeLast()
        }
        notesTableView.reloadData()
    }
}
