//
//  LoginReqest.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct LoginReqest: Content {
    let login: String
    let password: String
}
