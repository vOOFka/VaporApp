//
//  SignUpRequest.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct SignUpRequest: Content {
    let login: String
    let name: String
    let lastname: String
    let password: String
    let email: String
    let gender: String?
    let creditCard: String
    let bio: String?
}
