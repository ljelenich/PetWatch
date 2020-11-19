//
//  NotificationListTableViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/19/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NotificationListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        tableView.reloadData()
    }
    
    func fetchNotifications() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        NotificationController.shared.fetchNotifications(userUid: userUid) { (success) in
            switch success {
            case true:
                self.tableView.reloadData()
            case false:
                print("error")
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationController.shared.notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let notification = NotificationController.shared.notifications[indexPath.row]
        cell.textLabel?.text = notification.title
        cell.detailTextLabel?.text = notification.dateTime
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notificationToDelete = NotificationController.shared.notifications[indexPath.row].alertUid
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [notificationToDelete])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
