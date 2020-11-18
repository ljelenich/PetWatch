//
//  EmailViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/17/20.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImage?
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var genderTextLabel: UILabel!
    @IBOutlet weak var petTypeTextLabel: UILabel!
    @IBOutlet weak var breedTextLabel: UILabel!
    @IBOutlet weak var colorTextLabel: UILabel!
    @IBOutlet weak var birthdayTextLabel: UILabel!
    @IBOutlet weak var primaryFoodTextLabel: UILabel!
    @IBOutlet weak var allergiesTextLabel: UILabel!
    @IBOutlet weak var spayedNeuteredTextLabel: UILabel!
    @IBOutlet weak var microchipTextLabel: UILabel!
    @IBOutlet weak var vetNameTextLabel: UILabel!
    @IBOutlet weak var medicationsTextLabel: UILabel!
    @IBOutlet weak var emergencyContactTextLabel: UILabel!
    @IBOutlet weak var specialInstructionsTextLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    
    //MARK: - Properties
    
    var pets: Pet?
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
    
    //MARK: - Actions
    
    @IBAction func shareInfoButtonTapped(_ sender: Any) {
        sendEmail()
    }
    
    //MARK: - Helper Methods
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setSubject("Pet Information")
            mail.setMessageBody("</br>Name: \(pets?.name ?? "Name")</br></br>Gender: \(pets?.gender ?? "Gender")</br></br>Pet Type: \(pets?.petType ?? "Pet Type")</br></br>Breed: \(pets?.breed ?? "Breed")</br></br>Color: \(pets?.color ?? "Color")</br></br>Birthday: \(pets?.birthday ?? "Birthday")</br></br>Primary Food: \(pets?.primaryFood ?? "Primary Food")</br></br>Allergies: \(pets?.allergies ?? "Allergies")</br></br>Spayed/Neutered: \(pets?.spayedNeutered.description ?? "Spayed/Neutered")</br></br>Microchip: \(pets?.microchip ?? "Microchip")</br></br>Vet Name & Contact: \(pets?.vetName ?? "Vet Name")</br></br>Medications: \(pets?.medications ?? "Medications")</br></br>Emergency Contact: \(pets?.emergencyContact ?? "Emergency Contact")</br></br>Special Instructions: \(pets?.specialInstructions ?? "Special Instructions")</br></br>Additional Info: \(additionalInfoTextView.text ?? "Additional Info")", isHTML: true)
            let image = pets?.profileImage
            if image == nil {
                print("No image to send")
            } else {
                mail.addAttachmentData(image!.jpegData(compressionQuality: CGFloat(0.5))!, mimeType: "jpeg", fileName: "petphoto.jpeg")
            }
            present(mail, animated: true, completion: nil)
        } else {
            print("Device cannot send email.")
        }
    }
}

//MARK: - Email Extension

extension EmailViewController {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//MARK: - Keyboard Extensions

extension UIViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotifications(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardNotifications(notification: NSNotification) {

        var txtFieldY : CGFloat = 0.0
        let spaceBetweenTxtFieldAndKeyboard : CGFloat = 5.0

        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
            
            frame = self.view.convert(activeTextField.frame, from:activeTextField.superview)
            txtFieldY = frame.origin.y + frame.size.height
        }

        if let userInfo = notification.userInfo {
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardFrameY = keyBoardFrame!.origin.y
            let keyBoardFrameHeight = keyBoardFrame!.size.height

            var viewOriginY: CGFloat = 0.0
            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
                viewOriginY = 0.0
            } else {
                if txtFieldY >= keyBoardFrameY {
                    viewOriginY = (txtFieldY - keyBoardFrameY) + spaceBetweenTxtFieldAndKeyboard
                    if viewOriginY > keyBoardFrameHeight { viewOriginY = keyBoardFrameHeight }
                }
            }
            self.view.frame.origin.y = -viewOriginY
        }
    }
}

extension UIResponder {

    static weak var responder: UIResponder?

    static func currentFirst() -> UIResponder? {
        responder = nil
        UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
        return responder
    }

    @objc private func trap() {
        UIResponder.responder = self
    }
}
