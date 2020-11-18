//
//  PetListTableViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/18/20.
//

import UIKit

class PetListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func addPetButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func aspcaInfoButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PetController.shared.pets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let petToDisplay = PetController.shared.pets[indexPath.row]
        cell.textLabel?.text = petToDisplay.name
        cell.detailTextLabel?.text = petToDisplay.breed
        cell.imageView?.image = petToDisplay.profileImage

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
