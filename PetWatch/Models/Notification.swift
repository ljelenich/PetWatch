//
//  Notification.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import Foundation

class Notification {
    let userUid: String
    let alertUid: String
    let title: String
    let details: String
    let dateTime: String

    init(userUid: String, alertUid: String, title: String, details: String, dateTime: String) {
        self.userUid = userUid
        self.alertUid = alertUid
        self.title = title
        self.dateTime = dateTime
        self.details = details
    }
}

extension Notification: Equatable {
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.alertUid == rhs.alertUid
    }
}
