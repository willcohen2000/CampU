//
//  UserInformationTwoController.swift
//  CampU
//
//  Created by Will Cohen on 7/18/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit

class UserInformationTwoController: UIViewController {

    @IBOutlet weak var yearOfGraduationHolderView: UIView!
    @IBOutlet weak var ageHolderView: UIView!
    @IBOutlet weak var genderHolderView: UIView!
    @IBOutlet weak var yearOfGraduationTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var realName: String!
    var username: String!
    var profileImage: Data!
    
    var gender: String = "Male";
    
    var userUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureViews()
    }
    
    private func configureViews() {
        continueButton.layer.cornerRadius = (continueButton.frame.height / 2);
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if (yearOfGraduationTextField.text == "" || yearOfGraduationTextField.text == nil) {
            createErrorIdentifier(view: yearOfGraduationHolderView);
        } else if (ageTextField.text == "" || ageTextField == nil) {
            createErrorIdentifier(view: ageHolderView);
        } else if (ageTextField.text == "" || ageTextField == nil) {
            createErrorIdentifier(view: genderHolderView);
        } else {
            let completedUser = CompletedUser(realName: self.realName, username: self.username, yearOfGraduation: Int(yearOfGraduationTextField.text!)!, gender: self.gender, age: Int(ageTextField.text!)!, uid: self.userUID);
            DatabaseService.updateUserNodeWithInfo(completedUser: completedUser) { (success) in
                if (success) {
                    self.performSegue(withIdentifier: "toMainPageSegue", sender: nil);
                } else {
                    print("@willcohen handle error")
                }
            }
        }
    }
    
    @IBAction func genderDropdownButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    private func createErrorIdentifier(view: UIView) {
        view.layer.cornerRadius = 5.0;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = Colors.errorRed.cgColor;
    }
    
}
