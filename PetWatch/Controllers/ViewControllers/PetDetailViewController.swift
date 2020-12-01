//
//  PetDetailViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class PetDetailViewController: UIViewController {
    
    struct Row {
        var title: String
        var value: String
    }

    // MARK: - Outlets
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var pets: Pet?
    private var rows: [Row] = []
    let profileImagePicker = UIImagePickerController()
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupImageView()
        createRows()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func petImageButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }

    // MARK: - Navigation
    func showEditPetProfile() {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let updatePetVC = stroyboard.instantiateViewController(identifier: "") as! AddPetViewController
        updatePetVC.pet = pets
        self.navigationController?.pushViewController(updatePetVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is AddPetViewController
        {
            let vc = segue.destination as? AddPetViewController
            vc?.pet = pets
        }
    }
    
    // MARK: - Helper Methods
    func setupViews() {
        self.tableView.backgroundColor = UIColor(named: "lightGreyColor")
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
    }
    
    func setupImageView() {
        profileImagePicker.delegate = self
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
        petImageView.backgroundColor = UIColor.tealColor()
        petImageView.layer.cornerRadius = 10
        selectImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        selectImageButton.setTitleColor(.white, for: .normal)
        selectImageButton.backgroundColor = .clear
        
        guard let petUid = pets?.petUid else { return }
        let imageStorageRef = Storage.storage().reference().child("petProfileImage/\(petUid)")
        imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error == nil, let data = data {
                self.petImageView.image = UIImage(data: data)
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "petDetailsCell", for: indexPath)
        
        let row = rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.value
        cell.backgroundColor = UIColor(named: "lightGreyColor")
        
        return cell
    }
}

extension PetDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImageButton.setTitle("Change Image", for: .normal)
            petImageView.image = photo
            guard let petUid = pets?.petUid else { return }
            PetController.shared.setPetProfileImage(petUid, petImage: photo) { (result) in
                switch result {
                case .success(_):
                    print("photo was success")
                    NotificationCenter.default.post(name: PetDetailViewController.updateNotificationName, object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: "Pick a photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                self.profileImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(self.profileImagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                self.profileImagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(self.profileImagePicker, animated: true)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}
