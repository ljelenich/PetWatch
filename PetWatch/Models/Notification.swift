//
//  Notification.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import Foundation

class Notification {
    let uid: String
    let alertUid: String
    let title: String
    let dateTime: String

    init(uid: String, alertUid: String, title: String, dateTime: String) {
        self.uid = uid
        self.alertUid = alertUid
        self.title = title
        self.dateTime = dateTime
    }
}
