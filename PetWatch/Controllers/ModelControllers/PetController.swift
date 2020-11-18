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
    let firestoreDB = Firestore.firestore()
    
    //MARK: - Source of truth
    var pet: Pet?
    var pets: [Pet] = []
    
    //MARK: - CRUD Functions
    func createPet(name: String, profileImage: UIImage?, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, servingSize: String, snackFoods: String, feedingSchedule: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, vetContactInfo: String, medications: String, medicationInstructions: String, emergencyContact: String, emergencyContactInfo: String, specialInstructions: String, completion: @escaping (Result<Bool, UserError>) -> Void) {
        
        guard let image = profileImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }

        let filename = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profileImage").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
                return
            }

            storageRef.downloadURL(completion: { (downloadURL, err) in
                guard let uid =  Auth.auth().currentUser?.uid, let url = downloadURL else { return }
                self.firestoreDB.collection("pets").document(uid).setData(["name": name, "ownerUid": uid, "profileImageUrl": url, "gender": gender, "petType": petType, "breed": breed, "color": color, "birthday": birthday, "outsideSchedule": outsideSchedule, "primaryFood": primaryFood, "servingSize": servingSize, "snackFoods": snackFoods, "feedingSchedule": feedingSchedule, "allergies": allergies, "spayedNeutered": spayedNeutered, "microchip": microchip, "vetName": vetName, "vetContactInfo": vetContactInfo, "medications": medications, "medicationInstructions": medicationInstructions, "emergencyContact": emergencyContact, "emergencyContactInfo": emergencyContactInfo, "specialInstructions": specialInstructions])
                completion(.success(true))
            })
        })
    }
    
    func fetchPets(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection("pets").whereField("ownerUid", isEqualTo: uid).getDocuments() { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    guard let name = dictionary["name"] as? String,
                          let gender = dictionary["gender"] as? String,
                          let petType = dictionary["petType"] as? String,
                          let breed = dictionary["breed"] as? String,
                          let color = dictionary["color"] as? String,
                          let birthday = dictionary["birthday"] as? String,
                          let outsideSchedule = dictionary["outsideSchedule"] as? String,
                          let primaryFood = dictionary["primaryFood"] as? String,
                          let servingSize = dictionary["servingSize"] as? String,
                          let snackFood = dictionary["snackFood"] as? String,
                          let feedingSchedule = dictionary["feedingSchedule"] as? String,
                          let allergies = dictionary["allergies"] as? String,
                          let spayedNeutered = dictionary["spayedNeutered"] as? Bool,
                          let microchip = dictionary["microchip"] as? String,
                          let vetName = dictionary["vetName"] as? String,
                          let vetContactInfo = dictionary["vetContactInfo"] as? String,
                          let medications = dictionary["medications"] as? String,
                          let medicationInstructions = dictionary["medicationInstructions"] as? String,
                          let emergencyContact = dictionary["emergencyContact"] as? String,
                          let emergencyContactInfo = dictionary["emergencyContactInfo"] as? String,
                          let specialInstructions = dictionary["specialInstructions"] as? String else { return }
//                    let getPetInfo = Pet(name: name, gender: gender, petType: petType, breed: breed, color: color, birthday: birthday, outsideSchedule: outsideSchedule, primaryFood: primaryFood, servingSize: servingSize, snackFoods: snackFood, feedingSchedule: feedingSchedule, allergies: allergies, spayedNeutered: spayedNeutered, microchip: microchip, vetName: vetName, vetContactInfo: vetContactInfo, medications: medications, medicationInstructions: medicationInstructions, emergencyContact: emergencyContact, emergencyContactInfo: emergencyContactInfo, specialInstructions: specialInstructions)
//                    self.pets.append(getPetInfo)
                    completion(true)
                }
            }
        }
    }
    
    func fetchPetWithUID(uid: String, completion: @escaping (User) -> ()) {
        firestoreDB.collection("pets").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionary = document.data() else { return }
                guard let name = dictionary["name"] as? String else { return }
                guard let email = dictionary["email"] as? String else { return }
//                let user = User(name: name, email: email)
//                completion(user)
            } else {
                completion(error as! User)
                print("Document does not exist")
            }
        }
    }
    
    func updatePet(_ uid: String, name: String, gender: String, petType: String, breed: String, color: String, birthday: String, outsideSchedule: String, primaryFood: String, servingSize: String, snackFoods: String, feedingSchedule: String, allergies: String, spayedNeutered: Bool, microchip: String, vetName: String, vetContactInfo: String, medications: String, medicationInstructions: String, emergencyContact: String, emergencyContactInfo: String, specialInstructions: String, completion: @escaping (Result<Pet?, UserError>) -> Void) {
        firestoreDB.collection("pets").document(uid).setData(["name": name, "ownerUid": uid, "gender": gender, "petType": petType, "breed": breed, "color": color, "birthday": birthday, "outsideSchedule": outsideSchedule, "primaryFood": primaryFood, "servingSize": servingSize, "snackFoods": snackFoods, "feedingSchedule": feedingSchedule, "allergies": allergies, "spayedNeutered": spayedNeutered, "microchip": microchip, "vetName": vetName, "vetContactInfo": vetContactInfo, "medications": medications, "medicationInstructions": medicationInstructions, "emergencyContact": emergencyContact, "emergencyContactInfo": emergencyContactInfo, "specialInstructions": specialInstructions], merge: true) { error in
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
    
    func deletePetData(_ uid: String, completion: @escaping (Result<Bool, UserError>) -> Void) {
        firestoreDB.collection("pets").document(uid).delete() { error in
            if let error = error {
                print("There was an error deleting user: \(error.localizedDescription)")
                completion(.failure(.fbUserError(error)))
            } else {
                completion(.success(true))
            }
        }
    }
}
