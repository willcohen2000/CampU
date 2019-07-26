//
//  Database+Service.swift
//  CampU
//
//  Created by Will Cohen on 7/19/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DatabaseService {
    
    static func createUserNode(uid: String, email: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let userNodeReference = Database.database().reference().child("users").child(uid);
        userNodeReference.updateChildValues(["uid" : uid, "email" : email]) { (error, database) in
            if (error == nil) {
                completionHandler(true);
            } else {
                completionHandler(false);
            }
        }
    }
    
    static func updateUserNodeWithInfo(completedUser: CompletedUser, completionHandler: @escaping (_ success: Bool) -> Void) {
        let userNodeReference = Database.database().reference().child("users").child(completedUser.uid);
        let data: [String : Any] = ["name": completedUser.realName, "username": completedUser.username, "yearOfGrad": completedUser.yearOfGraduation, "age": completedUser.age, "gender": completedUser.age];
        userNodeReference.updateChildValues(data) { (error, database) in
            if (error == nil) {
                completionHandler(true);
            } else {
                completionHandler(false);
            }
        }
    }
    
}
