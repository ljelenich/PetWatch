//
//  PetDetailViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit

class PetDetailViewController: UIViewController {
    
    struct Row {
        var title: String
        var value: String
    }

    // MARK: - Outlets
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
  
    var pets: Pet?
    
    private var rows: [Row] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func petImageButtonTapped(_ sender: Any) {
    }

    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    private func createRows() {
        rows = [
            Row(title: "Name:", value: pets?.name ?? ""),
            Row(title: "Gender:", value: pets?.gender ?? ""),
            Row(title: "Pet Type:", value: pets?.petType ?? ""),
            Row(title: "Breed:", value: pets?.breed ?? ""),
            Row(title: "Color:", value: pets?.color ?? ""),
            Row(title: "Birthday:", value: pets?.birthday ?? ""),
            Row(title: "Outside Schedule:", value: pets?.outsideSchedule ?? ""),
            Row(title: "Primary Food:", value: pets?.primaryFood ?? ""),
            Row(title: "Allergies:", value: pets?.allergies ?? ""),
            Row(title: "Spayed/Neutered:", value: pets?.spayedNeutered.description ?? ""),
            Row(title: "Microchip:", value: pets?.microchip ?? ""),
            Row(title: "Vet Name:", value: pets?.vetName ?? ""),
            Row(title: "Medications:", value: pets?.medications ?? ""),
            Row(title: "Emergency Contact:", value: pets?.emergencyContact ?? "")
        ]
    }


}

extension PetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // change identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        let row = rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.value
        
        return cell
    }
}
