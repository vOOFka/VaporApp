//
//  File.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct UserProfile: Content {
    let user: User
    let name: String
    let lastname: String
    let email: String
    let gender: String?
    let creditCard: String
    let bio: String?
}
