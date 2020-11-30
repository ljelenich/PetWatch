//
//  User.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/16/20.
//

import Foundation

class User {
    var email: String
    var uid: String
    
    
    init(email: String, uid: String) {
        self.email = email
        self.uid = uid
    }
}
