//
//  PetController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/16/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class PetController {
    
    //MARK: - Shared Instance
    static let shared = PetController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection("pets")
    let storageRef = Storage.storage().reference()
    
    //MARK: - Source of truth
    var pet: Pet?
    var pets: [Pet] = []
    
    //MARK: - CRUD Functions
    func createPet(userUid: String, name: String, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, medications: String, emergencyContact: String, completion: @escaping (Result<Bool, UserError>) -> Void) {

        let filename = UUID().uuidString
        self.firestoreDB.document(filename).setData(["userUid": userUid, "petUid": filename, "name": name, "gender": gender, "petType": petType, "breed": breed, "color": color, "birthday": birthday, "outsideSchedule": outsideSchedule, "primaryFood": primaryFood, "allergies": allergies, "spayedNeutered": spayedNeutered, "microchip": microchip, "vetName": vetName, "medications": medications, "emergencyContact": emergencyContact])
        completion(.success(true))
    }
    
    func setPetProfileImage(_ petUid: String, petImage: UIImage?, completion: @escaping (Result<Bool, PetError>) -> Void) {
        guard let petImage = petImage else { return }
        guard let uploadProfileData = petImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = petUid
        storageRef.child("petProfileImage").child(filename).putData(uploadProfileData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
                return
            }
            self.storageRef.child("petProfileImage").child(filename).downloadURL(completion: { (downloadURL, err) in
                guard let petImageUrl = downloadURL?.absoluteString else { return }
                print(petImageUrl)
                Firestore.firestore().collection("pets").document(filename).setData(["imageUrl": petImageUrl], merge: true)
                completion(.success(true))
            })
        })
    }
    
    func fetchPets(userUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.whereField("userUid", isEqualTo: userUid).getDocuments() { (snapshot, error) in
            if (error != nil) == true {
                print("error")
                completion(false)
            } else {
                for document in snapshot!.documents {
                    let dictionary = document.data()
                    guard let name = dictionary["name"] as? String,
                          let gender = dictionary["gender"] as? String,
                          let petType = dictionary["petType"] as? String,
                          let breed = dictionary["breed"] as? String,
                          let color = dictionary["color"] as? String,
                          let birthday = dictionary["birthday"] as? String,
                          let outsideSchedule = dictionary["outsideSchedule"] as? String,
                          let primaryFood = dictionary["primaryFood"] as? String,
                          let allergies = dictionary["allergies"] as? String,
                          let spayedNeutered = dictionary["spayedNeutered"] as? Bool,
                          let microchip = dictionary["microchip"] as? String,
                          let vetName = dictionary["vetName"] as? String,
                          let medications = dictionary["medications"] as? String,
                          let emergencyContact = dictionary["emergencyContact"] as? String,
                          let userUid = dictionary["userUid"] as? String,
                          let petUid = dictionary["petUid"] as? String else { return }
                    let imageUrl = dictionary["imageUrl"] as? String ?? ""
                    
                    let getPetInfo = Pet(petUid: petUid, userUid: userUid, name: name, gender: gender, petType: petType, breed: breed, color: color, birthday: birthday, outsideSchedule: outsideSchedule, primaryFood: primaryFood, allergies: allergies, spayedNeutered: spayedNeutered, microchip: microchip, vetName: vetName, medications: medications, emergencyContact: emergencyContact, petImageUrl: imageUrl)
                    self.pets.append(getPetInfo)
                }
                completion(true)
            }
        }
    }
    
    func updatePet(_ petUid: String, name: String, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, medications: String, emergencyContactInfo: String, completion: @escaping (Result<Pet?, UserError>) -> Void) {
        firestoreDB.document(petUid).setData(["name": name, "gender": gender, "petType": petType, "breed": breed, "color": color, "birthday": birthday, "outsideSchedule": outsideSchedule, "primaryFood": primaryFood, "allergies": allergies, "spayedNeutered": spayedNeutered, "microchip": microchip, "vetName": vetName, "medications": medications, "emergencyContact": emergencyContactInfo], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
                return
            } else {
                completion(.success(self.pet))
                print("Document successfully updated")
            }
        }
    }
    
    func deletePet(petUid: String, completion: @escaping (Result<Bool, PetError>) -> Void) {
        firestoreDB.document(petUid).delete() { error in
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
