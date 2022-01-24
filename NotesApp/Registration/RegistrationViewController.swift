//
//  RegistrationViewController.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    static func create() -> RegistrationViewController? {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController
    }
    
    @IBOutlet weak var registrationTableView: UITableView!
    
    private var fields = [LoginField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFields()
        configureTableView()
        self.title = "Registration"
    }

    private func configureTableView() {
        registrationTableView.delegate = self
        registrationTableView.dataSource = self
        
        registrationTableView.register(UINib(nibName: LoginFieldTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoginFieldTableViewCell.identifier)
        registrationTableView.register(UINib(nibName: RegistrationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RegistrationTableViewCell.identifier)
        
        registrationTableView.separatorStyle = .none
        registrationTableView.tableFooterView = UIView()
    }
    
    private func prepareFields() {
        fields = [
            LoginField(type: .name, title: "Name"),
            LoginField(type: .mobile, title: "Phone number"),
            LoginField(type: .email, title: "Email"),
            LoginField(type: .password, title: "Password"),
            LoginField(type: .confirmPassword, title: "Confirm Password"),
            LoginField(type: .register, title: "Register")
        ]
    }
    
    private func getCellidentifierFor(_ type: LoginFieldTypeEnum) -> String {
        switch type {
        case .name, .mobile, .email, .password, .confirmPassword:
            return LoginFieldTableViewCell.identifier
        default:
            return RegistrationTableViewCell.identifier
        }
    }

}

// MARK:- UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        fields[textField.tag].update(value: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
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
        } else if let registerCell = cell as? RegistrationTableViewCell {
            registerCell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < fields.count else { return 0 }
        let field = fields[indexPath.row]
        if field.type == .register {
            return 124.0
        } else {
            return 70.0
        }
    }
}

// MARK:- RegistrationDelete
extension RegistrationViewController: RegistrationDelete {
    func didTouchRegistration() {
        registrationTableView.endEditing(true)
        var isInvalid = false
        for field in fields {
            if let value = field.value?.trimmingCharacters(in: .whitespacesAndNewlines), value.isEmpty, field.type != .register {
                self.view.makeToast("Please enter valid \(field.title)")
                isInvalid = true
                break
            } else if field.type == .email, let email = field.value, !Validator.isValidEmail(email) {
                self.view.makeToast("Please enter valid \(field.title)")
                isInvalid = true
                break
            } else if field.type == .mobile, let mobile = field.value, !Validator.isValidPhone(mobile) {
                self.view.makeToast("Please enter valid \(field.title)")
                isInvalid = true
                break
            } else if field.type == .password, let passwordCount = field.value?.trimmingCharacters(in: .whitespacesAndNewlines).count, passwordCount < 6 {
                self.view.makeToast("Please enter a strong password")
                isInvalid = true
                break
            } else if field.type == .confirmPassword, let passwordCount = field.value?.trimmingCharacters(in: .whitespacesAndNewlines).count, passwordCount < 6 {
                self.view.makeToast("Please enter a strong password")
                isInvalid = true
                break
            }
        }
        
        if isInvalid {
            return
        }
        
        if let password = fields.first(where: { $0.type == .password })?.value?.trimmingCharacters(in: .whitespacesAndNewlines), let confirmPassword = fields.first(where: { $0.type == .confirmPassword })?.value?.trimmingCharacters(in: .whitespacesAndNewlines), password != confirmPassword {
            self.view.makeToast("Password and confirm passwords are mismatched")
            return
        }
        
        guard let name = fields.first(where: { $0.type == .name })?.value,
              let email = fields.first(where: { $0.type == .email })?.value,
              let mobile = fields.first(where: { $0.type == .mobile })?.value,
              let password = fields.first(where: { $0.type == .password })?.value else {
                  self.view.makeToast("Something went wrong!")
                  return
              }
        let manager = DataManager.shared
        if manager.getUserWith(email) != nil || manager.getUserWith(mobile) != nil {
            self.view.makeToast("User already exist, please use sign in.")
            return
        }
        
        let user = User(id: manager.getUserUniqueId(), username: name, password: password, email: email, mobile: mobile, signedIn: false)
        manager.saveUser(user)
        
        let alertController = UIAlertController(title: "User created", message: "Constratulations, your registration got success, please goto login page and use sign in.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
