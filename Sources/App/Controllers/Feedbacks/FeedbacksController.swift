//
//  FeedbacksController.swift
//  
//
//  Created by Home on 01.03.2022.
//

import Vapor

final class FeedbacksController: Controllers {
    func getProductFeefbacks(_ req: Request) -> EventLoopFuture<FeedbacksResponse> {
        guard let body = try? req.content.decode(FeedbacksRequest.self) else {
            return handleFeedbacksError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        let currentProductFeedbacksPage = getPageOfFeedbacks(from: body)
        guard currentProductFeedbacksPage.isEmpty else {
            return handleFeedbacksError(by: req, with: "Нет такой категории товаров!")
        }
        
        print(body)
        let response = FeedbacksResponse(
            result: 1,
            errorMessage: nil,
            pageNumber: body.pageNumber,
            feedbacks: currentProductFeedbacksPage)
        return req.eventLoop.future(response)
    }
    
    private func getPageOfFeedbacks(from req: FeedbacksRequest) -> [Feedback?] {
        var neededProduct: Product?
        let caretaker = GoodsCaretaker()
        let allGoodsCategories = caretaker.retrieveGoodsCategories()
        
        allGoodsCategories.forEach { category in
            neededProduct = category.goods.first(where: { product in
                product.id == req.productId
            })
        }

        var pageIndex = 1
        var maxItemsPerPage = Int.max
        
        if let page = req.pageNumber{
            pageIndex = page
            maxItemsPerPage = 2
        }
        
        if let neededProduct = neededProduct,
           !neededProduct.feedbacks.isEmpty {
            let currentFeedbacksPage = getPage(page: pageIndex,
                                               allItems: neededProduct.feedbacks,
                                               maxItemsPerPage: maxItemsPerPage)
            return currentFeedbacksPage
        }
        return []
    }
    
    private func handleFeedbacksError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<FeedbacksResponse> {
        let response = FeedbacksResponse(
            result: 0,
            errorMessage: message,
            pageNumber: nil,
            feedbacks: [])
        return request.eventLoop.future(response)
    }
    
//    func getProductById(_ req: Request) -> EventLoopFuture<ProductResponce> {
//        guard let body = try? req.content.decode(ProductRequest.self) else {
//            return handleProductError(by: req, with: "Поправь прицел и повтори бросок!")
//        }
//
//        guard let neededProduct = extractionProductById(body) else {
//            return handleProductError(by: req, with: "Нет такого товара!")
//        }
//
//        print(body)
//        let response = ProductResponce(
//            result: 1,
//            errorMessage: nil,
//            product: neededProduct)
//        return req.eventLoop.future(response)
//    }
//
//    private func extractionProductById(_ req: ProductRequest) -> Product? {
//        let caretaker = GoodsCaretaker()
//        let allGoodsCategories = caretaker.retrieveGoodsCategories()
//        for category in allGoodsCategories {
//            guard let neededProduct = category.goods.first(where: { $0.id == req.productId }) else {
//                continue
//            }
//            return neededProduct
//        }
//        return nil
//    }
//    private func handleProductError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<ProductResponce> {
//        let response = ProductResponce(
//            result: 0,
//            errorMessage: message,
//            product: nil)
//        return request.eventLoop.future(response)
//    }
}
