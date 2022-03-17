//
//  BasketRequest.swift
//  
//
//  Created by Home on 08.03.2022.
//

import Vapor

struct BasketRequest: Content {
    let userId: Int
    let totalSumma: Int
    let productsIds: [Int]
}
