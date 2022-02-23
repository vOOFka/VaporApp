//
//  User.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct User: Content {
    let id: Int
    let login: String
    let password: String
    
    init(login: String, password: String) {
        self.id = abs(Int(UUID().uuidString.hash))
        self.login = login
        self.password = password
    }
}
