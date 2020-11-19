//
//  PetDetailViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit

class PetDetailViewController: UIViewController {
    
    struct Row {
        
    }

    // MARK: - Outlets
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func petImageButtonTapped(_ sender: Any) {
    }

    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
//    private func createRows() {
//        rows = [
//            Row(title: "Name:", value: pets?.name ?? ""),
//            Row(title: "Gender:", value: pets?.gender ?? ""),
//            Row(title: "Pet Type:", value: pets?.petType ?? ""),
//            Row(title: "Breed:", value: pets?.breed ?? ""),
//            Row(title: "Color:", value: pets?.color ?? ""),
//            Row(title: "Birthday:", value: pets?.birthday ?? ""),
//            Row(title: "Outside Schedule:", value: pets?.outsideSchedule ?? ""),
//            Row(title: "Primary Food:", value: pets?.primaryFood ?? ""),
//            Row(title: "Allergies:", value: pets?.allergies ?? ""),
//            Row(title: "Spayed/Neutered:", value: pets?.spayedNeutered.description ?? ""),
//            Row(title: "Microchip:", value: pets?.microchip ?? ""),
//            Row(title: "Vet Name:", value: pets?.vetName ?? ""),
//            Row(title: "Medications:", value: pets?.medications ?? ""),
//            Row(title: "Emergency Contact:", value: pets?.emergencyContact ?? "")
//        ]
//    }


}

extension PetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
