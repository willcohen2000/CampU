//
//  userInformationOneController.swift
//  CampU
//
//  Created by Will Cohen on 7/18/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit

class userInformationOneController: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var realNameHolderView: UIView!
    @IBOutlet weak var usernameHolderView: UIView!
    @IBOutlet weak var realNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var realName: String!
    var username: String!
    var profileImage: Data?
    
    var userUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureViews();
    }
    
    private func configureViews() {
        continueButton.layer.cornerRadius = (continueButton.frame.height / 2);
    }
    
    @IBAction func profileImageButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if (realNameTextField.text == "" || realNameTextField.text == nil) {
            createErrorIdentifier(view: realNameHolderView);
        } else if (userNameTextField.text == "" || userNameTextField == nil) {
            createErrorIdentifier(view: usernameHolderView);
        } else {
            self.realName = realNameTextField.text!
            self.username = userNameTextField.text!
            self.performSegue(withIdentifier: "toUserInfoTwoSegue", sender: nil);
        }
    }
    
    private func createErrorIdentifier(view: UIView) {
        view.layer.cornerRadius = 5.0;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = Colors.errorRed.cgColor;
    }
    
}

extension userInformationOneController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toUserInfoTwoSegue") {
            if let nextVC = segue.destination as? UserInformationTwoController {
                nextVC.realName = self.realName
                nextVC.username = self.username;
                nextVC.userUID = self.userUID;
                if let profileImage = self.profileImage {
                    nextVC.profileImage = profileImage;
                }
            }
        }
    }
}
