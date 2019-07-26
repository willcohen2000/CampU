//
//  Authentication+Service.swift
//  CampU
//
//  Created by Will Cohen on 7/19/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationService {
    
    static func logIn(userEmail: String, userPassword: String, completionHandler: @escaping (_ success: String) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if (error == nil) {
                if let user = user {
                    User.sharedInstance.uid = user.uid;
                }
                completionHandler("SUCCESS");
            } else {
                if let error = error {
                    print("what happened error")
                    completionHandler(error.localizedDescription);
                }
            }
        })
    }
    
    static func signUp(userEmail: String, userPassword: String, completionHandler: @escaping (_ success: String, _ uid: String) -> Void) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
            if (error == nil ) {
                if let user = user {
                    User.sharedInstance.uid = user.uid;
                    completionHandler("SUCCESS", user.uid);
                }
            } else {
                if let error = error {
                    completionHandler(error.localizedDescription, "");
                }
            }
        }
    }
    
    private func logInErrors(error: Error) {
       /* switch (error.localizedDescription) {
        case "The email address is badly formatted.":
            let invalidEmailAlert = UIAlertController(title: NSLocalizedString("Invalid Email", comment: "Invalid Email"), message:
                NSLocalizedString("It seems like you have put in an invalid email.", comment: "It seems like you have put in an invalid email."), preferredStyle: UIAlertControllerStyle.alert)
            invalidEmailAlert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: UIAlertActionStyle.default,handler: nil))
            controller.present(invalidEmailAlert, animated: true, completion: nil)
            break;
        case "The password is invalid or the user does not have a password.":
            let wrongPasswordAlert = UIAlertController(title: NSLocalizedString("Wrong Password", comment: "Wrong Password"), message:
                NSLocalizedString("It seems like you have entered the wrong password.", comment: "It seems like you have entered the wrong password."), preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            let wrongPasswordAlert = UIAlertController(title: NSLocalizedString("No Account Found", comment: "No Account Found"), message:
                NSLocalizedString("We couldn't find an account that corresponds to that email. Do you want to create an account?", comment: "We couldn't find an account that corresponds to that email. Do you want to create an account?"), preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: UIAlertActionStyle.default,handler: nil))
            wrongPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("Create Account", comment: "Create Account"), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                controller.performSegue(withIdentifier: "createAccountSegue", sender: nil)
            }))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        default:
            let loginFailedAlert = UIAlertController(title: NSLocalizedString("Error Logging In", comment: "Error Logging In"), message:
                "\(NSLocalizedString("There was an error logging you in. Please try again soon.", comment: "There was an error logging you in. Please try again soon.")) \n\nError: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
            loginFailedAlert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: UIAlertActionStyle.default,handler: nil))
            controller.present(loginFailedAlert, animated: true, completion: nil)
            break;
        }*/
    }
    
}
