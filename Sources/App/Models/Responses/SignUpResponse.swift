//
//  SignUpResponse.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct SignUpResponse: Content {
    var result: Int
    var userId: Int?
    var userMessage: String?
    var errorMessage: String?
}
