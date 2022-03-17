//
//  ProductCategory.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Vapor

struct ProductCategory: Content {
    let id: Int
    var goods: [Product]
}
