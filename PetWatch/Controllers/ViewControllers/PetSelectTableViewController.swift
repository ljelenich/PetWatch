//
//  PetSelectTableViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit
import FirebaseAuth

class PetSelectTableViewController: UITableViewController {

    // MARK: - Outlets
    
    // MARK: - Properties
    let pets: [Pet?] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPets()
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func infoButtonTapped(_ sender: Any) {
        presentInfoAlertController()
    }
    
    
    // MARK: - Helper Methods
    func presentInfoAlertController() {
        let infoAlertController = UIAlertController(title: "Select a Pet", message: "Here you can select one of your pets to send their information to a sitter or caretaker.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        infoAlertController.addAction(okAction)
        present(infoAlertController, animated: true)
    }
    
    func fetchPets() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        PetController.shared.fetchPets(userUid: userUid) { (success) in
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
        return pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petSelectCell", for: indexPath)
        cell.detailTextLabel?.text = PetController.shared.pet?.petType
        cell.textLabel?.text = PetController.shared.pet?.name

        return cell
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPetEmailVC" {
            let destinationVC = segue.destination as! EmailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let petToEmail = pets[indexPath.row]
            destinationVC.pets = petToEmail
        }
    }

}
