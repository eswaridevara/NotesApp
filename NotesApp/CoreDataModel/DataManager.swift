//
//  DataManager.swift
//  NotesApp
//
//  Created by VENKATESWARI on 22/01/22.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    let encryptionKey = "NotesAppEncyption1234"
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private init() { }
    
    // MARK:- User Managment
    func getUserWith(_ username: String?) -> User? {
        guard let username = username, let users = getAllUsers() else { return nil }
        return users.first(where: { $0.mobile == username || $0.email == username })
    }
    
    func getUserUniqueId() -> Int {
        guard let allUsers = getAllUsers()?.sorted(by: { $0.id < $1.id }) else { return 1 }
        return (allUsers.last?.id ?? 0) + 1
    }
    
    func getSignedInUser() -> User? {
        guard let allUsers = getAllUsers() else { return nil }
        return allUsers.first(where: { $0.signedIn == true })
    }
    
    func getAllUsers() -> [User]? {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        var users = [User]()
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results  {
                    if let id = result.value(forKey: "id") as? Int {
                        var user = User(id: id)
                        user.mobile = result.value(forKey: "mobile") as? String
                        user.email = result.value(forKey: "email") as? String
                        user.username = result.value(forKey: "name") as? String
                        if let base64Encoded = result.value(forKey: "password") as? String, let base64Decoded = Data(base64Encoded: base64Encoded, options: Data.Base64DecodingOptions(rawValue: 0))
                            .map({ String(data: $0, encoding: .utf8) }) {
                            user.password = base64Decoded
                        }
                        
                        if let signedIn = result.value(forKey: "signedIn") as? Bool {
                            user.signedIn = signedIn
                        }
                        users.append(user)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return users.isEmpty ? nil : users
    }
    
    func saveUser(_ user: User) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext, let userEntity = NSEntityDescription.entity(forEntityName: "UserModel", in: managedContext) else { return }
        let userObject = NSManagedObject(entity: userEntity, insertInto: managedContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.username, forKey: "name")
        
        if let utf8str = user.password?.data(using: .utf8) {
            let base64Encoded = utf8str.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            userObject.setValue(base64Encoded, forKey: "password")
        }
        
        userObject.setValue(user.email, forKey: "email")
        userObject.setValue(user.mobile, forKey: "mobile")
        userObject.setValue(user.signedIn, forKey: "signedIn")
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logoutUser(_ user: User) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        fetchRequest.predicate = NSPredicate(format: "id = %d", user.id)
        
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let result = results.first {
                result.setValue(false, forKey: "signedIn")
                
                do {
                    try managedContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loginUser(_ user: User) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        fetchRequest.predicate = NSPredicate(format: "id = %d", user.id)
        
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let result = results.first {
                result.setValue(true, forKey: "signedIn")
                
                do {
                    try managedContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK:- Notes Managment
    
    func getNoteUniqueId() -> Int {
        guard let allNotes = getAllNotes()?.sorted(by: { $0.noteId < $1.noteId }) else { return 1 }
        return (allNotes.last?.noteId ?? 0) + 1
    }
    
    func getAllNotes(userId: Int? = nil) -> [Note]? {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesModel")
        if let id = userId {
            fetchRequest.predicate = NSPredicate(format: "userId = %d", id)
        }
        var notes = [Note]()
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results  {
                    if let id = result.value(forKey: "noteId") as? Int, let userId = result.value(forKey: "userId") as? Int {
                        var note = Note(noteId: id, userId: userId)
                        note.title = result.value(forKey: "title") as? String
                        note.description = result.value(forKey: "noteDescription") as? String
                        if let imageData = result.value(forKey: "images") as? [Data] {
                            let imageArray = imageData.compactMap({ UIImage(data: $0) })
                            note.images = imageArray
                        }
                        notes.append(note)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return notes.isEmpty ? nil : notes
    }
    
    func getNotesForUserId(_ id: Int) -> [Note]? {
        getAllNotes(userId: id)
    }
    
    func saveNote(_ note: Note) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext, let noteEntity = NSEntityDescription.entity(forEntityName: "NotesModel", in: managedContext) else { return }
        let noteObject = NSManagedObject(entity: noteEntity, insertInto: managedContext)
        noteObject.setValue(note.noteId, forKey: "noteId")
        noteObject.setValue(note.userId, forKey: "userId")
        noteObject.setValue(note.title, forKey: "title")
        noteObject.setValue(note.description, forKey: "noteDescription")
        if let images = note.images, !images.isEmpty {
            let dataArray = images.map({ $0.pngData() })
            noteObject.setValue(dataArray, forKey: "images")
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}
