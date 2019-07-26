//
//  LoginController.swift
//  CampU
//
//  Created by Will Cohen on 7/18/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var userInformationHolderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureViews();
    }
    
    private func configureViews() {
        logInButton.layer.cornerRadius = (logInButton.frame.height / 2);
        userInformationHolderView.layer.borderColor = Colors.centralBlack.cgColor;
        userInformationHolderView.layer.borderWidth = 1.0;
        userInformationHolderView.layer.cornerRadius =  5.0;
    }
   
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let userEmail = emailTextField.text else {
            return;
        }
        guard let userPassword = passwordTextField.text else {
            return;
        }
        
        AuthenticationService.logIn(userEmail: userEmail, userPassword: userPassword) { (success) in
            if (success == "SUCCESS") {
                self.performSegue(withIdentifier: "toMainSegue", sender: nil);
            } else {
                print("@willcohen handle error")
            }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
