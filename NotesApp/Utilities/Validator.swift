//
//  Validator.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import UIKit

struct Validator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPhone(_ phone: String) -> Bool {
        let expression = "^[6-9]\\d{9}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", expression)
        return phonePred.evaluate(with: phone)
    }
}
