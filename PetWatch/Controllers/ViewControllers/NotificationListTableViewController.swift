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
        updateViews()
    }
    
    func fetchNotifications() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        NotificationController.shared.fetchNotifications(userUid: userUid) { (success) in
            switch success {
            case true:
                self.updateViews()
            case false:
                print("error")
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = NotificationController.shared.notifications[indexPath.row]
        let notificationVC = NotificationViewController()
        notificationVC.alertUid = notification.alertUid
        navigationController?.pushViewController(notificationVC, animated: true)
//        self.performSegue(withIdentifier: "showNotification", sender: self)
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showNotification" {
//            guard let indexPath = tableView.indexPathForSelectedRow,
//                let destinationVC = segue.destination as? NotificationViewController else {return}
//            let notification = NotificationController.shared.notifications[indexPath.row]
//            destinationVC.notification = notification
//        }
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notificationToDelete = NotificationController.shared.notifications[indexPath.row]
            guard let indexOfNotification = NotificationController.shared.notifications.firstIndex(of: notificationToDelete) else { return }
            NotificationController.shared.deleteNotification(alertUid: notificationToDelete.alertUid) { (result) in
                switch result {
                case .success(_):
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [notificationToDelete.alertUid])
                    NotificationController.shared.notifications.remove(at: indexOfNotification)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
