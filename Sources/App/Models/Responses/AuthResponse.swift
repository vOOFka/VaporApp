//
//  AuthResponse.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct AuthResponse: Content {
    var result: Int
    var user: User?
    var userMessage: String?
    var errorMessage: String?
}
