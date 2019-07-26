//
//  User.swift
//  CampU
//
//  Created by Will Cohen on 7/19/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import Foundation

final class User {
    static let sharedInstance = User()
    private init() { }

    var uid: String!
    
}
