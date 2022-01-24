//
//  LoginViewController.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit
import Toast_Swift

class LoginViewController: UIViewController {
    
    static func create() -> LoginViewController? {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
    
    @IBOutlet weak var loginTableView: UITableView!
    
    private var fields = [LoginField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFields()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func configureTableView() {
        loginTableView.delegate = self
        loginTableView.dataSource = self
        
        loginTableView.register(UINib(nibName: LoginFieldTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoginFieldTableViewCell.identifier)
        loginTableView.register(UINib(nibName: LoginActionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoginActionTableViewCell.identifier)
        
        loginTableView.separatorStyle = .none
        loginTableView.tableFooterView = UIView()
    }
    
    private func prepareFields() {
        fields = [
            LoginField(type: .username, title: "Email/Phone"),
            LoginField(type: .password, title: "Password"),
            LoginField(type: .login, title: "Login")
        ]
    }
    
    private func getCellidentifierFor(_ type: LoginFieldTypeEnum) -> String {
        switch type {
        case .username:
            return LoginFieldTableViewCell.identifier
        case .password:
            return LoginFieldTableViewCell.identifier
        default:
            return LoginActionTableViewCell.identifier
        }
    }

}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < fields.count else { return UITableViewCell() }
        let field = fields[indexPath.row]
        let cellIdentifier = getCellidentifierFor(field.type)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let fieldCell = cell as? LoginFieldTableViewCell {
            fieldCell.prepareWith(field)
            fieldCell.fieldTextField.tag = indexPath.row
            fieldCell.fieldTextField.delegate = self
        } else if let loginCell = cell as? LoginActionTableViewCell {
            loginCell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < fields.count else { return 0 }
        let field = fields[indexPath.row]
        if field.type == .login {
            return 124.0
        } else if field.type == .username {
            return 200.0
        } else {
            return 70.0
        }
    }
}

// MARK:- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        fields[textField.tag].update(value: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK:- LoginActionDelegate
extension LoginViewController: LoginActionDelegate {
    func didTouchLogin() {
        loginTableView.endEditing(true)
        guard let username = fields.first(where: { $0.type == .username })?.value?.trimmingCharacters(in: .whitespacesAndNewlines), let password = fields.first(where: { $0.type == .password })?.value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if username.isEmpty {
            self.view.makeToast("Please enter valid username")
            return
        }
        
        if let user = DataManager.shared.getUserWith(username) {
            if password == user.password, let controller = TabViewController.create() {
                DataManager.shared.loginUser(user)
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                self.view.makeToast("Password doesn't match!")
            }
        } else {
            self.view.makeToast("No user found with \(username), please register and try again.")
        }
    }
    
    func didTouchRegistration() {
        guard let controller = RegistrationViewController.create() else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK:- CoreDataAction
extension LoginViewController {
    
}
