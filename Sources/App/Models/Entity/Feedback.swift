//
//  Feedback.swift
//  
//
//  Created by Home on 01.03.2022.
//

import Vapor

struct Feedback: Content {
    let id: Int
    let userId: Int
    let comment: String
}
