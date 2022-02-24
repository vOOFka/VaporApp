//
//  GoodsRequest.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Vapor

struct GoodsRequest: Content {
    let categoryId: Int
    let pageNumber: Int?
}
