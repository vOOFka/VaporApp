//
//  FeedbacksRequest.swift
//  
//
//  Created by Home on 01.03.2022.
//

import Vapor

struct FeedbacksRequest: Content {
    let productId: Int
    let feedbackId: Int?
    let pageNumber: Int?
    let newFeedback: Feedback?
}
