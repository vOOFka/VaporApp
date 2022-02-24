//
//  GoodsResponse.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Vapor

struct GoodsResponse: Content {
    var result: Int
    var errorMessage: String?
    let pageNumber: Int?
    let goods: [Product]?
}
