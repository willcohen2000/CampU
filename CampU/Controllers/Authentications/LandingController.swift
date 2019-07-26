//
//  LandingController.swift
//  CampU
//
//  Created by Will Cohen on 7/18/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit

class LandingController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureViews();
    }
    
    private func configureViews() {
        signUpButton.layer.borderColor = Colors.centralBlack.cgColor;
        signUpButton.layer.borderWidth = 1.0;
        signUpButton.layer.cornerRadius = (logInButton.frame.height / 2);
        logInButton.layer.cornerRadius = (logInButton.frame.height / 2);
    }
    
    

}
