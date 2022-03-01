//
//  FeedbacksResponse.swift
//  
//
//  Created by Home on 01.03.2022.
//

import Vapor

struct FeedbacksResponse: Content {
    var result: Int
    var errorMessage: String?
    let pageNumber: Int?
    let feedbacks: [Feedback?]
}
