//
//  LoginRequest.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct LoginRequest: Content {
    let login: String
    let password: String
}
