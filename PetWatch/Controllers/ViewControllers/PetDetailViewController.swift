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
