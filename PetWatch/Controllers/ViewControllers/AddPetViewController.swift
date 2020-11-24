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
    
    //MARK: - Properties
    var petUid: String?
    var pet: Pet? {
        didSet {
            guard let pet = pet else { return }
            petUid = pet.petUid
        }
    }
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
        setupViews()
    }
    
    //MARK: - Actions
    
    @IBAction func savePetButtonTapped(_ sender: Any) {
        savePet()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
    }
    
    func populateFields () {
        guard let pet = pet else { return }
        nameTextField.text = pet.name
        genderTextField.text = pet.gender
        petTypeTextField.text = pet.petType
        breedTextField.text = pet.breed
        colorTextField.text = pet.color
        birthdayTextField.text = pet.birthday
        outsideScheduleTextField.text = pet.outsideSchedule
        primaryFoodTextField.text = pet.primaryFood
        allergiesTextField.text = pet.allergies
        if pet.spayedNeutered == true {
            spayedSegmentedControl.selectedSegmentIndex = 0
        } else {
            spayedSegmentedControl.selectedSegmentIndex = 1
        }
        microchipTextField.text = pet.microchip
        vetNameAndPhoneTextField.text = pet.vetName
        medicationsTextField.text = pet.medications
        emergencyContactTextField.text = pet.emergencyContact
    }
    
    func savePet() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let spayedNeutered: Bool
        if spayedSegmentedControl.selectedSegmentIndex == 0 {
            spayedNeutered = true
        } else {
            spayedNeutered = false
        }
        guard let name = nameTextField.text, let gender = genderTextField.text, let petType = petTypeTextField.text, let breed = breedTextField.text, let color = colorTextField.text, let birthday = birthdayTextField.text, let outsideSchedule = outsideScheduleTextField.text, let primaryFood = primaryFoodTextField.text, let allergies = allergiesTextField.text, let microchip = microchipTextField.text, let vetName = vetNameAndPhoneTextField.text, let medications = medicationsTextField.text, let emergencyContact = emergencyContactTextField.text else { return }
        
        if ((pet?.petUid.isEmpty) != nil) {
            guard let petUid = pet?.petUid else { return }
            PetController.shared.updatePet(petUid, name: name, gender: gender, petType: petType, breed: breed, color: color, birthday: birthday, outsideSchedule: outsideSchedule, primaryFood: primaryFood, allergies: allergies, spayedNeutered: spayedNeutered, microchip: microchip, vetName: vetName, medications: medications, emergencyContactInfo: emergencyContact) { (result) in
                switch result {
                case .success(_):
                    self.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            PetController.shared.createPet(userUid: userUid, name: name, gender: gender, petType: petType, breed: breed, color: color, birthday: birthday, outsideSchedule: outsideSchedule, primaryFood: primaryFood, allergies: allergies, spayedNeutered: spayedNeutered, microchip: microchip, vetName: vetName, medications: medications, emergencyContact: emergencyContact) { (result) in
                switch result {
                case .success(_):
                    self.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
//        PetController.shared.createPet(userUid: userUid, name: name, gender: gender, petType: petType, breed: breed, color: color, birthday: birthday, outsideSchedule: outsideSchedule, primaryFood: primaryFood, allergies: allergies, spayedNeutered: spayedNeutered, microchip: microchip, vetName: vetName, medications: medications, emergencyContact: emergencyContact) { (result) in
//            switch result {
//            case .success(_):
//                self.dismiss()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
