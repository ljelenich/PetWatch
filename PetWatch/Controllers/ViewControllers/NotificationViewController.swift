//
//  NotificationViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import UIKit
import UserNotifications
import FirebaseAuth
import FirebaseFirestore

class NotificationViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var disableAlertButton: UIButton!
    
    var isExistinNotification: Bool?
    var alertUid: String?
    var setDateTime: String?
    var notification: Notification? {
        didSet {
            guard let notification = notification else { return }
            alertUid = notification.alertUid
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermissionForNotifications()
        setupTextFields()
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        scheduleNotification(date: datePicker.date)
        dismiss()
    }
    
    @IBAction func disableButtonTapped(_ sender: Any) {
        guard let alertUid = notification?.alertUid else { return }
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == alertUid {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            NotificationController.shared.deleteNotification(alertUid: alertUid) { (success) in
                switch success {
                case .success(_):
                    print("success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.dismiss()
        }
    }
    
    @IBAction func datePickerPressed(_ sender: Any) {
        let date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        setDateTime = formatter.string(from: date)
        datePickerTextField.text = setDateTime
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        titleTextField.text = notification?.title
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
        disableAlertButton.layer.borderColor = UIColor.lightGray.cgColor
        disableAlertButton.layer.borderWidth = CGFloat(2)
    }
    
    func setupTextFields() {
        titleTextField.text = notification?.title
        datePickerTextField.text = notification?.dateTime
    }

    func requestPermissionForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                print("All good in the hood")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(date: Date) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = description
        content.sound = UNNotificationSound.default
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching:newComponents, repeats: true)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let setDateTime = formatter.string(from: date)

        if ((notification?.alertUid.isEmpty) != nil) {
            guard let alertUid = notification?.alertUid else { return }
            updateToFirestore(alertUid: alertUid, title: title, dateTime: setDateTime)
        } else {
            saveToFirestore(alertUid: identifier, title: title, dateTime: setDateTime)
        }
        
    }
    
    func saveToFirestore(alertUid: String, title: String, dateTime: String) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        NotificationController.shared.createNotification(userUid: userUid, alertUid: alertUid, title: title, dateTime: dateTime) { (result) in
            switch result {
            case .success(_):
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateToFirestore(alertUid: String, title: String, dateTime: String) {
        NotificationController.shared.updateNotification(alertUid: alertUid, title: title, dateTime: dateTime) { (result) in
            switch result {
            case .success(_):
                print("success")
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
