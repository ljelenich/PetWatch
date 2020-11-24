//
//  PetSelectTableViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit
import FirebaseAuth

class PetSelectTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPets()
        setupViews()
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
                print("pets fetched")
            case false:
                print("error")
            }
        }
    }
    
    func setupViews() {
        self.tableView.backgroundColor = UIColor(named: "lightGreyColor")
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PetController.shared.pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petSelectCell", for: indexPath)
        let petToDisplay = PetController.shared.pets[indexPath.row]
        cell.detailTextLabel?.text = petToDisplay.breed
        cell.textLabel?.text = petToDisplay.name
        cell.backgroundColor = UIColor(named: "lightGreyColor")

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPetEmailVC" {
            let destinationVC = segue.destination as? EmailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let petToEmail = PetController.shared.pets[indexPath.row]
            destinationVC?.pets = petToEmail
        }
    }

}

