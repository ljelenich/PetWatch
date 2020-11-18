//
//  AddPetViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/18/20.
//

import UIKit

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
    @IBOutlet weak var spayedNeuteredTextField: UITextField!
    @IBOutlet weak var microchipTextField: UITextField!
    @IBOutlet weak var vetNameAndPhoneTextField: UITextField!
    @IBOutlet weak var medicationsTextField: UITextField!
    @IBOutlet weak var emergencyContactTextField: UITextField!
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func savePetButtonTapped(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
