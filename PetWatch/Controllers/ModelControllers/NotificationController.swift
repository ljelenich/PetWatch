//
//  NotificationController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NotificationController {
    
    //MARK: - Shared Instance
    static let shared = NotificationController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection("notifications")
    
    //MARK: - Source of truth
    var notification: Notification?
    var notifications: [Notification] = []
    
    //MARK: - CRUD Functions
    func createNotification(userUid: String, alertUid: String, title: String, dateTime: String, completion: @escaping (Result<Bool, NotificationError>) -> Void) {
        firestoreDB.document(alertUid).setData(["userUid": userUid, "alertUid": alertUid, "title": title, "dateTime": dateTime]) { error in
            if let error = error {
                print("Error writing document: \(error)")
                completion(.failure(.fbUserError(error)))
            } else {
                print("Document successfully written!")
                completion(.success(true))
            }
        }
    }
    
    func fetchNotifications(userUid: String, completion: @escaping (Bool) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        firestoreDB.whereField("userUid", isEqualTo: userUid).getDocuments() { (snapshot, error) in
            if (error != nil) == true {
                print("error")
                completion(false)
            } else {
                for document in snapshot!.documents {
                    let dictionary = document.data()
                    let userUid = dictionary["userUid"] as? String ?? ""
                    let alertUid = dictionary["alertUid"] as? String ?? ""
                    let title = dictionary["title"] as? String ?? ""
                    let dateTime = dictionary["dateTime"] as? String ?? ""
                    let getNotifications = Notification(userUid: userUid, alertUid: alertUid, title: title, dateTime: dateTime)
                    self.notifications.append(getNotifications)
                }
                completion(true)
            }
        }
    }
    
    func updateNotification(petUid: String, title: String, dateTime: String, completion: @escaping (Result<Notification?, NotificationError>) -> Void) {
        firestoreDB.document(petUid).setData([title: title, dateTime: dateTime], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
                return
            } else {
                completion(.success(self.notification))
                print("Document successfully updated")
            }
        }
    }
    
    func deleteNotification(alertUid: String, completion: @escaping (Result<Bool, NotificationError>) -> Void) {
        firestoreDB.document(alertUid).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
                completion(.failure(.fbUserError(error)))
            } else {
                print("Document successfully removed!")
                completion(.success(true))
            }
        }
    }
}

