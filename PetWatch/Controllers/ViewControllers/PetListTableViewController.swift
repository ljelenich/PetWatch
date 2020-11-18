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
    
    @IBAction func addPetButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func aspcaInfoButtonTapped(_ sender: Any) {
        
    }
}

extension PetListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()

    }
}
