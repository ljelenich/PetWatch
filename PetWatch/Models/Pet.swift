//
//  Pet.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/16/20.
//

import UIKit

class Pet {
    var petUid: String
    var userUid: String
    var name: String
    var gender: String
    var petType: String
    var breed: String
    var color: String
    var birthday: String
    var outsideSchedule: String
    var primaryFood: String
    var allergies: String
    var spayedNeutered: Bool
    var microchip: String
    var vetName: String
    var medications: String
    var emergencyContact: String
    var petImageUrl: String?
    

    init(petUid: String, userUid: String, name: String, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, medications: String, emergencyContact: String, petImageUrl: String = "") {
 
        self.petUid = petUid
        self.userUid = userUid
        self.name = name
        self.gender = gender
        self.petType = petType
        self.breed = breed
        self.color = color
        self.birthday = birthday
        self.outsideSchedule = outsideSchedule
        self.primaryFood = primaryFood
        self.allergies = allergies
        self.spayedNeutered = spayedNeutered
        self.microchip = microchip
        self.vetName = vetName
        self.medications = medications
        self.emergencyContact = emergencyContact
        self.petImageUrl = petImageUrl
    }
}

extension Pet: Equatable {
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        return lhs.petUid == rhs.petUid
    }
}
