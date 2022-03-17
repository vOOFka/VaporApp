//
//  BaseResponse.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct BaseResponse: Content {
    var result: Int
    var errorMessage: String?
}
