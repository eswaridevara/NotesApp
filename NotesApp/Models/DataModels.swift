//
//  DataModels.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import Foundation
import UIKit

enum LoginFieldTypeEnum {
    case username, password, login
    case name, mobile, email, confirmPassword, register
}

enum NoteFieldTypeEnum {
    case title, description, image, addImage
}

struct LoginField {
    var type: LoginFieldTypeEnum
    var title: String
    var value: String?
    
    mutating func update(value: String?) {
        self.value = value
    }
}

struct User {
    var id: Int
    var username: String?
    var password: String?
    var email: String?
    var mobile: String?
    var signedIn = false
}


struct Note {
    var noteId: Int
    var userId: Int
    var title: String?
    var description: String?
    var images: [UIImage]?
    
    mutating func update(title: String?) {
        self.title = title
    }
    
    mutating func update(description: String?) {
        self.description = description
    }
    
    mutating func update(images: [UIImage]?) {
        self.images = images
    }
}

struct NoteField {
    var type: NoteFieldTypeEnum
    var title: String?
    var value: String?
    var image: UIImage?
    
    mutating func update(title: String?) {
        self.title = title
    }
    
    mutating func update(value: String?) {
        self.value = value
    }
    
    mutating func update(image: UIImage) {
        self.image = image
    }
}
