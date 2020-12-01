//
//  PetListTableViewCell.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/24/20.
//

import UIKit
import FirebaseStorage

class PetListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    

    var pet: Pet? {
        didSet {
            setupViews()
        }
    }

    func setupViews() {
        self.backgroundColor = UIColor(named: "lightGreyColor")
        petImageView.layer.cornerRadius = petImageView.bounds.width / 2
        self.petImageView.clipsToBounds = true
        
        guard let pet = pet else { return }
        petNameLabel.text = "\(pet.name)"
        petBreedLabel.text = "\(pet.breed)"
        if pet.petImageUrl == nil {
            petImageView.image = UIImage(named: "PetWatchLogo")
        } else {
            let petUid = pet.petUid
            let imageStorageRef = Storage.storage().reference().child("petProfileImage/\(petUid)")
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error == nil, let data = data {
                    self.petImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
