//
//  UserController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/16/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UserController {
    
    //MARK: - Shared Instance
    static let shared = UserController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore()
    
    //MARK: - Source of truth
    var user: User?
    var users: User?
    
    //MARK: - CRUD Functions
    func createUser(completion: @escaping (Result<Bool, UserError>) -> Void) {
        Auth.auth().signInAnonymously() { (user, error) in
            if let error = error {
                print("Error: Sign in anonymously failed! \(error.localizedDescription)")
                return
            }
                        
            if let uid = user?.user.uid {
                print("uid: \(uid)")
                self.firestoreDB.collection("users").document(uid).setData(["uid": uid])
                completion(.success(true))
            }
        }
    }
}

