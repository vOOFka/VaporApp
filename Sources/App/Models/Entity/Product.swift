//
//  File.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Vapor

struct Product: Content {
    let id: Int
    let name: String
    let price: Int
    let description: String
    var feedbacks: [Feedback?] = []
}
