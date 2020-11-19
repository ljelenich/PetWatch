//
//  PetListTableViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/18/20.
//

import UIKit
import FirebaseAuth

class PetListTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //MARK: - Actions
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
    
    @IBAction func aspcaInfoButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.aspca.org/pet-care/general-pet-care/emergency-care-your-pet")! as URL, options: [:], completionHandler: nil)
    }
}

extension PetListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PetController.shared.pets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let petToDisplay = PetController.shared.pets[indexPath.row]
        UITableViewCell().textLabel?.text = petToDisplay.name
        UITableViewCell().detailTextLabel?.text = petToDisplay.breed
        UITableViewCell().imageView?.image = petToDisplay.profileImage
        
        return UITableViewCell()

    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }
}
