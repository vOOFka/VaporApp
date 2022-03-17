//
//  ProductResponce.swift
//  
//
//  Created by Home on 25.02.2022.
//

import Vapor

struct ProductResponce: Content {
    var result: Int
    var errorMessage: String?
    let product: Product?
}
