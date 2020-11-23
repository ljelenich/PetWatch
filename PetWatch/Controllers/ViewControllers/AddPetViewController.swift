//
//  AddPetViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/18/20.
//

import UIKit
import FirebaseAuth

class AddPetViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var petTypeTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var outsideScheduleTextField: UITextField!
    @IBOutlet weak var primaryFoodTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    @IBOutlet weak var microchipTextField: UITextField!
    @IBOutlet weak var vetNameAndPhoneTextField: UITextField!
    @IBOutlet weak var medicationsTextField: UITextField!
    @IBOutlet weak var emergencyContactTextField: UITextField!
    @IBOutlet weak var spayedSegmentedControl: UISegmentedControl!
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func savePetButtonTapped(_ sender: Any) {
        savePet()
    }
    
    //MARK: - Helper Functions
    func savePet() {
//<<<<<<< HEAD
//        guard let userUid = Auth.auth().currentUser?.uid else { return }
//        guard let name = nameTextField.text else { return }
//        let gender = genderTextField.text, let petType = petTypeTextField.text, let breed = breedTextField.text, let color = colorTextField.text, let birthday = birthdayTextField.text, let outsideSchedule = outsideScheduleTextField.text, let primaryFood = primaryFoodTextField.text, let allergies = allergiesTextField.text,
//            PetController;.shared.createPet(userUid: userUid, name: name, gender: "", petType: "", breed: "", color: "", birthday: "", outsideSchedule: "", primaryFood: "", allergies: "", spayedNeutered: true, microchip: "", vetName: "", medications: "", emergencyContact: "", specialInstructions: "") { (result) in
//            switch result {
//            case .success(_):
//                self.dismiss()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//=======
//>>>>>>> ad1862a282bb5c54732b9086f18e6e8d5a4b794f

        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let spayedNeutered: Bool
        if spayedSegmentedControl.selectedSegmentIndex == 0 {
            spayedNeutered = true
        } else {
            spayedNeutered = false
        }
        guard let name = nameTextField.text, let gender = genderTextField.text, let petType = petTypeTextField.text, let breed = breedTextField.text, let color = colorTextField.text, let birthday = birthdayTextField.text, let outsideSchedule = outsideScheduleTextField.text, let primaryFood = primaryFoodTextField.text, let allergies = allergiesTextField.text, let microchip = microchipTextField.text, let vetName = vetNameAndPhoneTextField.text, let medications = medicationsTextField.text, let emergencyContact = emergencyContactTextField.text else { return }
        PetController.shared.createPet(userUid: userUid, name: name, gender: gender, petType: petType, breed: breed, color: color, birthday: birthday, outsideSchedule: outsideSchedule, primaryFood: primaryFood, allergies: allergies, spayedNeutered: spayedNeutered, microchip: microchip, vetName: vetName, medications: medications, emergencyContact: emergencyContact) { (result) in
            switch result {
            case .success(_):
                self.dismiss()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
