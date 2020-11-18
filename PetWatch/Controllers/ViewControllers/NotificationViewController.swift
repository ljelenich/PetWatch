//
//  NotificationViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("Save Pressed")
    }
    @IBAction func datePickerPressed(_ sender: Any) {
    }
    @IBAction func disableButtonTapped(_ sender: Any) {
        print("disable Pressed")
    }
    

}
