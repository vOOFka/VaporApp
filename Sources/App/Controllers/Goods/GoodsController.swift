//
//  GoodsController.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Vapor

final class GoodsController: Controllers {
    func getCategory(_ req: Request) -> EventLoopFuture<GoodsResponse> {
        guard let body = try? req.content.decode(GoodsRequest.self) else {
            return handleGoodsError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard let currentCategoryPage = getPageOfCatalog(from: body) else {
            return handleGoodsError(by: req, with: "Нет такой категории товаров!")
        }
        
        print(body)
        let response = GoodsResponse(
            result: 1,
            errorMessage: nil,
            pageNumber: body.pageNumber,
            goods: currentCategoryPage.goods)
        return req.eventLoop.future(response)
    }
    
    private func getPageOfCatalog(from req: GoodsRequest) -> ProductCategory? {
        let caretaker = GoodsCaretaker()
        let allGoodsCategories = caretaker.retrieveGoodsCategories()
        let currentCategory = allGoodsCategories.first(where: { $0.id == req.categoryId })
        var pageIndex = 1
        var maxItemsPerPage = Int.max
        
        if let page = req.pageNumber{
            pageIndex = page
            maxItemsPerPage = 2
        }
        
        if let currentCategory = currentCategory,
           !currentCategory.goods.isEmpty {
            let currentCategoryPage = getPage(page: pageIndex, allItems: currentCategory.goods, maxItemsPerPage: maxItemsPerPage)
            return ProductCategory(id: req.categoryId, goods: currentCategoryPage)
        }
        return nil
    }
    
    private func handleGoodsError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<GoodsResponse> {
        let response = GoodsResponse(
            result: 0,
            errorMessage: message,
            pageNumber: nil,
            goods: nil)
        return request.eventLoop.future(response)
    }
    
    func getProductById(_ req: Request) -> EventLoopFuture<ProductResponce> {
        guard let body = try? req.content.decode(ProductRequest.self) else {
            return handleProductError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard let neededProduct = extractionProductById(body) else {
            return handleProductError(by: req, with: "Нет такого товара!")
        }
        
        print(body)
        let response = ProductResponce(
            result: 1,
            errorMessage: nil,
            product: neededProduct)
        return req.eventLoop.future(response)
    }
    
    private func extractionProductById(_ req: ProductRequest) -> Product? {
        let caretaker = GoodsCaretaker()
        let allGoodsCategories = caretaker.retrieveGoodsCategories()
        for category in allGoodsCategories {
            guard let neededProduct = category.goods.first(where: { $0.id == req.productId }) else {
                continue
            }
            return neededProduct
        }
        return nil
    }
    private func handleProductError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<ProductResponce> {
        let response = ProductResponce(
            result: 0,
            errorMessage: message,
            product: nil)
        return request.eventLoop.future(response)
    }
}
