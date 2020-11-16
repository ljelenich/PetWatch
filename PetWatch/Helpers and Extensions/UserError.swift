//
//  UserError.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/16/20.
//

import Foundation

enum UserError: LocalizedError {
    case fbUserError(Error)
    case unwrapError
    
    var errorDescription: String {
        switch self {
        case .fbUserError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .unwrapError:
            return "Unable to unwrap this user."
        }
    }
}
