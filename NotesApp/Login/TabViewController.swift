//
//  TabViewController.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class TabViewController: UITabBarController {
    
    static func create() -> TabViewController? {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as? TabViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
