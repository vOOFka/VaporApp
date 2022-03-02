//
//  FeedbacksController.swift
//  
//
//  Created by Home on 01.03.2022.
//

import Vapor

final class FeedbacksController: Controllers {
    private var currentProduct: Product?
    // MARK: - Get product feedbacks response
    func getProductFeedbacks(_ req: Request) -> EventLoopFuture<FeedbacksResponse> {
        guard let body = try? req.content.decode(FeedbacksRequest.self) else {
            return handleFeedbacksError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        getProduct(from: body)
        guard currentProduct != nil else {
            return handleFeedbacksError(by: req, with: "Нет такого товара!")
        }
        
        let currentProductFeedbacksPage = getPageOfFeedbacks(from: body)
        guard currentProductFeedbacksPage.isEmpty else {
            return handleFeedbacksError(by: req, with: "У товара нет отзывов!")
        }
        
        print(body)
        let response = FeedbacksResponse(
            result: 1,
            errorMessage: nil,
            pageNumber: body.pageNumber,
            feedbacks: currentProductFeedbacksPage)
        return req.eventLoop.future(response)
    }
    
    private func getProduct(from req: FeedbacksRequest, newFeedback: Feedback? = nil, removeFeedbackId: Int = -1) {
        let caretaker = GoodsCaretaker()
        var allGoodsCategories = caretaker.retrieveGoodsCategories()
        var indexCurrentCategory = -1
        var indexCurrentProduct = -1
        
        for (index, category) in allGoodsCategories.enumerated() {
            indexCurrentProduct = category.goods.firstIndex(where: { product in
                product.id == req.productId
            }) ?? -1
            if indexCurrentProduct >= 0 {
                indexCurrentCategory = index
                currentProduct = category.goods[indexCurrentProduct]
            }
        }
        
        if newFeedback != nil,
           indexCurrentCategory >= 0,
           indexCurrentProduct >= 0 {
            allGoodsCategories[indexCurrentCategory].goods[indexCurrentProduct].feedbacks.append(newFeedback)
            caretaker.save(goodsCategories: allGoodsCategories)
        }
        
        if removeFeedbackId >= 0,
           indexCurrentCategory >= 0,
           indexCurrentProduct >= 0 {
            allGoodsCategories[indexCurrentCategory].goods[indexCurrentProduct].feedbacks.removeAll(where: { feedback in
                feedback?.id == removeFeedbackId
            })
            caretaker.save(goodsCategories: allGoodsCategories)
        }
    }
    
    private func getPageOfFeedbacks(from req: FeedbacksRequest) -> [Feedback?] {
        var pageIndex = 1
        var maxItemsPerPage = Int.max
        
        if let page = req.pageNumber{
            pageIndex = page
            maxItemsPerPage = 2
        }
        
        if let currentProduct = currentProduct,
           !currentProduct.feedbacks.isEmpty {
            let currentFeedbacksPage = getPage(page: pageIndex,
                                               allItems: currentProduct.feedbacks,
                                               maxItemsPerPage: maxItemsPerPage)
            return currentFeedbacksPage
        }
        return []
    }
    // MARK: - Add feedbacks response
    func addFeedback(_ req: Request) -> EventLoopFuture<FeedbacksResponse> {
        guard let body = try? req.content.decode(FeedbacksRequest.self) else {
            return handleFeedbacksError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        getProduct(from: body, newFeedback: body.newFeedback)
        guard currentProduct != nil else {
            return handleFeedbacksError(by: req, with: "Нет такого товара!")
        }
        
        print(body)
        let response = FeedbacksResponse(
            result: 1,
            errorMessage: nil,
            pageNumber: body.pageNumber,
            feedbacks: currentProduct?.feedbacks ?? [])
        return req.eventLoop.future(response)
    }
    // MARK: - Remove feedbacks response
    func removeFeedback(_ req: Request) -> EventLoopFuture<FeedbacksResponse> {
        guard let body = try? req.content.decode(FeedbacksRequest.self) else {
            return handleFeedbacksError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        getProduct(from: body, removeFeedbackId: body.feedbackId ?? -1)
        guard currentProduct != nil else {
            return handleFeedbacksError(by: req, with: "Нет такого товара!")
        }
        
        print(body)
        let response = FeedbacksResponse(
            result: 1,
            errorMessage: nil,
            pageNumber: body.pageNumber,
            feedbacks: currentProduct?.feedbacks ?? [])
        return req.eventLoop.future(response)
    }
    // MARK: - Handle errors
    private func handleFeedbacksError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<FeedbacksResponse> {
        let response = FeedbacksResponse(
            result: 0,
            errorMessage: message,
            pageNumber: nil,
            feedbacks: [])
        return request.eventLoop.future(response)
    }
}

