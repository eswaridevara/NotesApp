//
//  ProfileViewController.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = DataManager.shared.getSignedInUser()
        nameLabel.text = user?.username
        emailLabel.text = user?.email
        phoneLabel.text = user?.mobile
    }

    @IBAction func didTouchLogout() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let user = user else { return }
        DataManager.shared.logoutUser(user)
        appDelegate.gotoLogin()
    }
}
