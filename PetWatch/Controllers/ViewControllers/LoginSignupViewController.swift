//
//  LoginSignupViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/17/20.
//

import UIKit
import FirebaseAuth

class LoginSignupViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dismissKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
    
    //MARK: - Actions
    @IBAction func signupButtonTapped(_ sender: Any) {
        signupButtonTapped()
    }
    
    //MARK: - Helper Functions
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "lightGreyColor")
    }
    
    func signupButtonTapped() {
        UserController.shared.createUser() { (result) in
            switch result {
            case .success(_):
                print("success")
                self.showPetListVC()
            case .failure(let error):
                print(error.localizedDescription)
                Auth.auth().handleFirebaseErrors(error: error, vc: self)
            }
        }
    }
    
    func showPetListVC() {
        DispatchQueue.main.async {
            let viewController: UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}
