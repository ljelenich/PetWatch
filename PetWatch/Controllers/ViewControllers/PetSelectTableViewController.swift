//
//  PetSelectTableViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit
import FirebaseAuth

class PetSelectTableViewController: UITableViewController {
    
    //MARK: - Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPets()
        setupViews()
        PetController.shared.pets.removeAll()
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
            case false:
                print("error")
            }
        }
    }
    
    func setupViews() {
        self.tableView.backgroundColor = UIColor(named: "lightGreyColor")
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
    }
    
    func refreshViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to see updated pet list.")
        refresh.addTarget(self, action: #selector(updateViews), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func updateViews() {
        fetchPets()
        PetController.shared.pets.removeAll()
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

