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
    var profileImage: UIImage?
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
    

    init(petUid: String, userUid: String, profileImage: UIImage? = UIImage(), name: String, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, medications: String, emergencyContact: String) {

        self.petUid = petUid
        self.userUid = userUid
        self.profileImage = profileImage
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
    }
}
