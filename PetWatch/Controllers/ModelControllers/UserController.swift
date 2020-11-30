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
    func createUser(email: String, password: String, completion: @escaping (Result<Bool, UserError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("There was an error authorizing user: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
            }
            guard let uid = user?.user.uid else { return }
            self.firestoreDB.collection("users").document(uid).setData(["email": email, "uid": uid])
            completion(.success(true))
        })
    }
    
    func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        firestoreDB.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionary = document.data() else { return }
                guard let email = dictionary["email"] as? String else { return }
                let user = User(email: email, uid: uid)
                completion(user)
            } else {
                completion(error as! User)
                print("Document does not exist")
            }
        }
    }
    
    func updateUserProfileImage(_ uid: String, profileImage: UIImage?, completion: @escaping (Result<Bool, UserError>) -> Void) {
        guard let profileImage = profileImage else { return }
        guard let uploadProfileData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = Auth.auth().currentUser?.uid ?? ""
        let storageRef = Storage.storage().reference()
        storageRef.child("profileImage").child(filename).putData(uploadProfileData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
                return
            }
            completion(.success(true))
        })
    }
    
    func deleteUserData(_ uid: String, completion: @escaping (Result<Bool, UserError>) -> Void) {
        firestoreDB.collection("users").document(uid).delete() { error in
            if let error = error {
                print("There was an error deleting user: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
            } else {
                completion(.success(true))
            }
        }
    }
}

