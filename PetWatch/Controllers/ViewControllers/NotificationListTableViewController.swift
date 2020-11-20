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

    var refresh: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
    }
    
    func refreshViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull see update")
        refresh.addTarget(self, action: #selector(updateViews), for: .valueChanged)
        tableView?.addSubview(refresh)
    }
    
    func fetchNotifications() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        NotificationController.shared.fetchNotifications(userUid: userUid) { (success) in
            switch success {
            case true:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
                
            case false:
                print("error")
            }
        }
    }
    
    @objc func updateViews() {
        fetchNotifications()
        NotificationController.shared.notifications.removeAll()
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
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationVC = stroyboard.instantiateViewController(identifier: "notificationVC") as! NotificationViewController
        notificationVC.notification = notification
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showNotification" {
//            guard let indexPath = tableView.indexPathForSelectedRow,
//                let destinationVC = segue.destination as? NotificationViewController else {return}
//            let notification = NotificationController.shared.notifications[indexPath.row].alertUid
//            destinationVC.alertUid = notification
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
