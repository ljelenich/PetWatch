//
//  NotificationController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import Foundation
import FirebaseFirestore

class NotificationController {
    
    static let shared = NotificationController()
    let firestoreDB = Firestore.firestore().collection("notifications")
    var notifications: [Notification] = []
    
    func createNotification(uid: String, alertUid: String, title: String, dateTime: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        firestoreDB.document(uid).collection("alerts").document(alertUid).setData(["uid": uid, "title": title, "dateTime": dateTime])
        completion(.success(true))
    }
    
    func fetchNotifications(uid: String, completion: @escaping (Bool) -> Void) {
        
        firestoreDB.document(uid).collection("alerts").getDocuments() { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    guard let uid = dictionary["uid"] as? String,
                          let alertUid = dictionary["alertUid"] as? String,
                          let title = dictionary["title"] as? String,
                          let dateTime = dictionary["dateTime"] as? String else { return }
                    let getNotifications = Notification(uid: uid, alertUid: alertUid, title: title, dateTime: dateTime)
                        self.notifications.append(getNotifications)
                    completion(true)
                }
            }
        }
    }
}

