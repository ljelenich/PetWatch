//
//  PetListTableViewController.swift
//  PetWatch
//
//  Created by Shean Bjoralt on 11/18/20.
//

import UIKit
import FirebaseAuth

class PetListTableViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var refresh: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchPets()
        setupViews()
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
    
    //MARK: - Helper Functions
    func setupViews() {
        self.tableView.backgroundColor = UIColor(named: "lightGreyColor")
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
    }
    
    func fetchPets() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        PetController.shared.fetchPets(userUid: userUid) { (success) in
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
    
    func refreshViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to see updated pet list.")
        refresh.addTarget(self, action: #selector(updateViews), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func updateViews() {
        fetchPets()
        PetController.shared.pets.removeAll()
    }
}

//MARK: - Table View Entension

extension PetListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PetController.shared.pets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath)
        let petToDisplay = PetController.shared.pets[indexPath.row]
        cell.textLabel?.text = petToDisplay.name
        cell.detailTextLabel?.text = petToDisplay.breed
        cell.imageView?.image = petToDisplay.profileImage
        cell.backgroundColor = UIColor(named: "lightGreyColor")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let petToDelete = PetController.shared.pets[indexPath.row]
            guard let indexOfPet = PetController.shared.pets.firstIndex(of: petToDelete) else { return }
            PetController.shared.deletePet(petUid: petToDelete.petUid) { (result) in
                switch result {
                case .success(_):
                    PetController.shared.pets.remove(at: indexOfPet)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPetDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? PetDetailViewController else { return }
                let petToSend = PetController.shared.pets[indexPath.row]
                destinationVC.pets = petToSend
            }
        }
    }
}
