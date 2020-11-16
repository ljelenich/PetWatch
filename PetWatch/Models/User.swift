//
//  User.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/16/20.
//

import Foundation

class User {
    var username: String
    var email: String
    var uid: String
    
    init(username: String, email: String, uid: String) {
        self.email = email
        self.username = username
        self.uid = uid
    }
}
