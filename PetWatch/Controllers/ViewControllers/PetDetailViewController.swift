//
//  PetDetailViewController.swift
//  PetWatch
//
//  Created by Alex Kennedy on 11/18/20.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol PetDetailViewControllerDelegate: AnyObject {
    func petDetailViewControllerSelected(image: UIImage)
}

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
    weak var delegate: PetDetailViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        createRows()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func petImageButtonTapped(_ sender: Any) {
        
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - Helper Methods
    func setupViews() {
        petNameLabel.text = PetController.shared.pet?.name
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
        
        return cell
    }
}

extension PetDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImageButton.setTitle("Select Photo", for: .normal)
            petImageView.image = photo
            delegate?.petDetailViewControllerSelected(image: photo)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Pick a photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}
