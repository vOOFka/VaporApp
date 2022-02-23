//
//  LoginResponse.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct LoginResponse: Content {
    var result: Int
    var user: User?
    var errorMessage: String?
}
