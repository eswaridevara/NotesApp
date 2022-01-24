//
//  NotesViewController.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTableView: UITableView!
    
    private var notes = [Note]()
    
    private let manager = DataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notes"
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = manager.getSignedInUser(), let notes = manager.getAllNotes(userId: user.id) {
            self.notes = notes
            notesTableView.reloadData()
        }
    }
    
    private func configureTableView() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        notesTableView.register(UINib(nibName: NotesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotesTableViewCell.identifier)
        
        notesTableView.separatorStyle = .singleLine
        notesTableView.tableFooterView = UIView()
    }
    
    @IBAction func didTouchAddNotes() {
        guard let controller = AddNotesViewController.create() else { return }
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection = 0
        if notes.count > 0 {
            tableView.backgroundView = nil
            numOfSection = 1
        } else {
            let noNotesLabel = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height:tableView.bounds.size.height))
            noNotesLabel.text = "No Notes Added"
            noNotesLabel.textColor = .systemGray
            noNotesLabel.textAlignment = .center
            tableView.backgroundView = noNotesLabel
            
        }
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath)
        if indexPath.row < notes.count, let noteCell = cell as? NotesTableViewCell {
            let note = notes[indexPath.row]
            noteCell.prepareWith(note)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < notes.count, let controller = AddNotesViewController.create() else { return }
        let note = notes[indexPath.row]
        controller.selectedNote = note
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
