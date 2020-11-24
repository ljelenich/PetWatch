//
//  EmailViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/17/20.
//

import UIKit
import MessageUI
import FirebaseStorage

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    struct Row {
        var title: String
        var value: String
    }
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var sharePetButton: UIButton!
    
    //MARK: - Properties
    
    var pets: Pet?
    
    private var rows: [Row] = []
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        createRows()
        dismissKeyboardOnTap()
        testImage()
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
    
    func setupViews() {
        additionalInfoTextView.placeholder = "Add additional directions or information here"
        self.tableView.backgroundColor = UIColor(named: "lightGreyColor")
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
        self.additionalInfoTextView.backgroundColor = UIColor(named: "lightGreyColor")
        additionalInfoTextView.layer.borderWidth = CGFloat(2)
        additionalInfoTextView.layer.borderColor = UIColor.lightGray.cgColor
        sharePetButton.layer.borderWidth = CGFloat(2)
        sharePetButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func testImage() {
        guard let petUid = pets?.petUid else { return }
        let imageStorageRef = Storage.storage().reference().child("petImageUrl/\(petUid)")
        imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error == nil, let data = data {
                print("test data: \(UIImage(data: data))")
//                mail.addAttachmentData(data, mimeType: "jpeg", fileName: "petphoto.jpeg")
            }
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setSubject("Pet Information")
            mail.setMessageBody("<hr><h2>Pet Information</h2>Name: \(pets?.name ?? "")</br></br>Gender: \(pets?.gender ?? "")</br></br>Pet Type: \(pets?.petType ?? "")</br></br>Breed: \(pets?.breed ?? "")</br></br>Color: \(pets?.color ?? "")</br></br>Birthday: \(pets?.birthday ?? "")</br></br><hr><h2>Care Information</h2>Outside Schedule: \(pets?.outsideSchedule ?? "")</br></br>Primary Food: \(pets?.primaryFood ?? "")</br></br>Allergies: \(pets?.allergies ?? "")</br></br><hr><h2>Medical Information</h2>Spayed/Neutered: \(pets?.spayedNeutered.description ?? "")</br></br>Microchip: \(pets?.microchip ?? "")</br></br>Vet Name & Contact: \(pets?.vetName ?? "")</br></br>Medications: \(pets?.medications ?? "")</br></br>Emergency Contact: \(pets?.emergencyContact ?? "")</br></br><hr><h2>Additional Information</h2>Additional Info: \(additionalInfoTextView.text ?? "")</br></br><hr>", isHTML: true)
            let image = pets?.profileImage
            if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                mail.addAttachmentData(imageData, mimeType: "jpeg", fileName: "petphoto.jpeg")
            } else {
                print("No image to send")
            }
            present(mail, animated: true, completion: nil)
        } else {
            print("Device cannot send email.")
        }
    }
    
    private func createRows() {
        rows = [
            Row(title: "Name:", value: pets?.name ?? ""),
            Row(title: "Gender:", value: pets?.gender ?? ""),
            Row(title: "Pet Type:", value: pets?.petType ?? ""),
            Row(title: "Breed:", value: pets?.breed ?? ""),
            Row(title: "Color:", value: pets?.color ?? ""),
            Row(title: "Birthday:", value: pets?.birthday ?? ""),
            Row(title: "Outside Schedule:", value: pets?.outsideSchedule ?? ""),
            Row(title: "Primary Food:", value: pets?.primaryFood ?? ""),
            Row(title: "Allergies:", value: pets?.allergies ?? ""),
            Row(title: "Spayed/Neutered:", value: pets?.spayedNeutered.description ?? ""),
            Row(title: "Microchip:", value: pets?.microchip ?? ""),
            Row(title: "Vet Name:", value: pets?.vetName ?? ""),
            Row(title: "Medications:", value: pets?.medications ?? ""),
            Row(title: "Emergency Contact:", value: pets?.emergencyContact ?? "")
        ]
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

//MARK: - Table View Extension

extension EmailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petEmailCell", for: indexPath)
        
        let row = rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.value
        cell.backgroundColor = UIColor(named: "lightGreyColor")
        return cell
    }
}
