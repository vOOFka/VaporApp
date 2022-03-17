//
//  User.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct User: Content {
    var id: Int
    let login: String
    let password: String
    let userProfile: UserProfile
}
