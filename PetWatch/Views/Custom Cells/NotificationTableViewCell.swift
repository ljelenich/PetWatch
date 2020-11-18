//
//  NotificationTableViewCell.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var disableSwitch: UISwitch!
    @IBAction func disableSwitchToggled(_ sender: Any) {
    }
    
    //MARK: - Properties
    var notification: Notification? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        titleLabel.text = notification?.title
        timeLabel.text = notification?.dateTime
    }
    
}
