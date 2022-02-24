//
//  GoodsController.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Vapor

final class GoodsController {
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
        
        if req.pageNumber != nil {
            pageIndex = req.pageNumber!
            maxItemsPerPage = 3
        }
        
        if let currentCategory = currentCategory,
           currentCategory.goods.isEmpty {
            let currentCategoryPage = getPageProducts(page: pageIndex, allItems: currentCategory.goods, maxItemsPerPage: maxItemsPerPage)
            return ProductCategory(id: req.categoryId, goods: currentCategoryPage)
        }
        return nil
    }
    
    private func getPageProducts(page: Int, allItems: [Product], maxItemsPerPage: Int) -> [Product] {
        let startIndex = Int(page * maxItemsPerPage)
        var length = max(0, allItems.count - startIndex)
        length = min(Int(maxItemsPerPage), length)
        
        guard length > 0 else { return [] }
        
        return Array(allItems[startIndex..<(startIndex + length)])
    }
    
    private func handleGoodsError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<GoodsResponse> {
        let response = GoodsResponse(
            result: 0,
            errorMessage: nil,
            pageNumber: nil,
            goods: nil)
        return request.eventLoop.future(response)
    }
}
