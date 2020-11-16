//
//  Pet.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/16/20.
//

import UIKit

class Pet {
    
    var profileImage: UIImage?
    var name: String
    var gender: String
    var petType: String
    var breed: String
    var color: String
    var birthday: String
    var outsideSchedule: String
    var primaryFood: String
    var servingSize: String
    var snackFoods: String
    var feedingSchedule: String
    var allergies: String
    var spayedNeutered: Bool
    var microchip: String
    var vetName: String
    var vetContactInfo: String
    var medications: String
    var medicationInstructions: String
    var emergencyContact: String
    var emergencyContactInfo: String
    var specialInstructions: String
    
    init(profileImage: UIImage?, name: String, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, servingSize: String, snackFoods: String, feedingSchedule: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, vetContactInfo: String, medications: String, medicationInstructions: String, emergencyContact: String, emergencyContactInfo: String, specialInstructions: String) {
        self.profileImage = profileImage
        self.name = name
        self.gender = gender
        self.petType = petType
        self.breed = breed
        self.color = color
        self.birthday = birthday
        self.outsideSchedule = outsideSchedule
        self.primaryFood = primaryFood
        self.servingSize = servingSize
        self.snackFoods = snackFoods
        self.feedingSchedule = feedingSchedule
        self.allergies = allergies
        self.spayedNeutered = spayedNeutered
        self.microchip = microchip
        self.vetName = vetName
        self.vetContactInfo = vetContactInfo
        self.medications = medications
        self.medicationInstructions = medicationInstructions
        self.emergencyContact = emergencyContact
        self.emergencyContactInfo = emergencyContactInfo
        self.specialInstructions = specialInstructions
    }
}
