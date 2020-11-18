//
//  PetDetailViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit

class PetDetailViewController: UIViewController {

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


}

extension PetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
