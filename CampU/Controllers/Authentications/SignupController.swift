//
//  SignupController.swift
//  CampU
//
//  Created by Will Cohen on 7/18/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userInformationHolderView: UIView!
    
    var userUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureViews();
    }
    
    private func configureViews() {
        userInformationHolderView.layer.borderColor = Colors.centralBlack.cgColor;
        userInformationHolderView.layer.cornerRadius  = 5.0;
        userInformationHolderView.layer.borderWidth = 1.0;
        signUpButton.layer.cornerRadius = (signUpButton.frame.height / 2);
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard let userEmail = emailTextField.text else {
            return;
        }
        guard let userPassword = passwordTextField.text else {
            return;
        }
        guard let userConfirmPassword = confirmPasswordTextField.text else {
            return;
        }
        
        if (userPassword == userConfirmPassword) {
            AuthenticationService.signUp(userEmail: userEmail, userPassword: userPassword) { (success, uid) in
                if (success == "SUCCESS") {
                    DatabaseService.createUserNode(uid: uid, email: userEmail, completionHandler: { (completed) in
                        if (completed) {
                            self.userUID = uid;
                            self.performSegue(withIdentifier: "toUserInfoOneSegue", sender: nil);
                        } else {
                            
                        }
                    })
                } else {
                    print("@willcohen handle signup error");
                }
            }
        }
    
    }
    
}

extension SignupController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toUserInfoOneSegue") {
            if let nextVC = segue.destination as? userInformationOneController {
                nextVC.userUID = self.userUID;
            }
        }
    }
}
