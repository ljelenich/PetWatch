//
//  PetListTableViewCell.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/24/20.
//

import UIKit
import FirebaseStorage
import Kingfisher

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
        
        if pet.petImageUrl == "" {
            petImageView.image = UIImage(named: "PetWatchLogo")
            print("nada")
        } else {
            guard let imageUrl = pet.petImageUrl else { return }
            if let url = URL(string: imageUrl) {
                let placeholder = UIImage(named: "PetWatchLogo")
                petImageView.kf.indicatorType = .activity
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                petImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
        }
    }
}
