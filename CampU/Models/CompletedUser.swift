//
//  CompletedUser.swift
//  CampU
//
//  Created by Will Cohen on 7/19/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import Foundation

class CompletedUser {
    
    var realName: String!
    var username: String!
    var yearOfGraduation: Int!
    var gender: String!
    var age: Int!
    var uid: String!
    
    init(realName: String, username: String, yearOfGraduation: Int, gender: String, age: Int, uid: String) {
        self.realName = realName;
        self.username = username;
        self.yearOfGraduation = yearOfGraduation;
        self.gender = gender;
        self.age = age;
        self.uid = uid;
    }
    
}
