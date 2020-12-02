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

    //MARK: - Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshViews()
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        handleUpdate()
    }
    
    //MARK: - Helper Functions
    func handleUpdate() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewPet), name: NotificationViewController.updateNotificationName, object: nil)
    }
    
    @objc func handleNewPet() {
        NotificationController.shared.notifications.removeAll()
        fetchNotifications()
        tableView.reloadData()
    }
    
    func refreshViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull see update")
        refresh.addTarget(self, action: #selector(updateViews), for: .valueChanged)
        tableView?.addSubview(refresh)
        self.tableView.backgroundColor = UIColor(named: "lightGreyColor")
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
        cell.backgroundColor = UIColor(named: "lightGreyColor")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = NotificationController.shared.notifications[indexPath.row]
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationVC = stroyboard.instantiateViewController(identifier: "notificationVC") as! NotificationViewController
        notificationVC.notification = notification
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }

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
