//
//  NotificationViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import UIKit
import UserNotifications
import FirebaseAuth

class NotificationViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    var alertUid: String?
    var notification: Notification? {
        didSet {
            alertUid = notification?.alertUid
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(alertUid)
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        scheduleNotification(date: datePicker.date)
        dismiss()
    }
    
    @IBAction func disableButtonTapped(_ sender: Any) {
        print("disable Pressed")
    }
    
    //MARK: - Helper Functions
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
        saveToFirestore(alertUid: identifier, title: title, description: description, dateTime: setDateTime)
    }
    
    func saveToFirestore(alertUid: String, title: String, description: String, dateTime: String) {
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
    
    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
