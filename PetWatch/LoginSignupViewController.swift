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
    }
    
    //MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButtonTapped()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        signupButtonTapped()
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        handleForgotPassword()
    }
    
    //MARK: - Helper Functions
    func signupButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty, password.count >= 6 else { return alertUserSignUpError() }
        UserController.shared.createUser(email: email, password: password) { (result) in
            switch result {
            case .success(_):
                print("success")
//                self.showPetListVC()
            case .failure(let error):
                print(error.localizedDescription)
                Auth.auth().handleFirebaseErrors(error: error, vc: self)
            }
        }
    }
    
    func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else { return alertUserSignUpError() }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                Auth.auth().handleFirebaseErrors(error: error, vc: self)
            } else {
                print("success")
//                self.showPetListVC()
            }
        }
    }
    
    func alertUserSignUpError() {
        let alert = UIAlertController(title: "Woops", message: "Please fill out all the fields to create a new account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    func showPetListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    func handleForgotPassword()  {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Send password reset", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
}
