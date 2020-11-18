//
//  NotificationTableViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import UIKit
import UserNotifications
import FirebaseAuth

class NotificationTableViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        NotificationController.shared.fetchNotifications(uid: uid) { (success) in
            switch success {
            case true:
                print(success)
                self.tableView.reloadData()
            case false:
                print("error")
            }
        }
    }

    
}

extension NotificationTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(NotificationController.shared.notifications.count)
        return NotificationController.shared.notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = NotificationController.shared.notifications[indexPath.row]
        cell.textLabel?.text = notification.title
        cell.detailTextLabel?.text = notification.dateTime
        return cell
    }
}
