//
//  LaunchScreenCopyViewController.swift
//  PetWatch
//
//  Created by LAURA JELENICH on 11/18/20.
//

import UIKit
import FirebaseAuth

class LaunchScreenCopyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "lightGreyColor")

        if Auth.auth().currentUser == nil {
            let viewController: UIViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
            
        } else {
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}
