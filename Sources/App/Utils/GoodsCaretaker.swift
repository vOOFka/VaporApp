//
//  GoodsCaretaker.swift
//  
//
//  Created by Home on 24.02.2022.
//

import Foundation

final class GoodsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "ProductCategory"
    
    func save(goodsCategories: [ProductCategory]) {
        do {
            let data = try self.encoder.encode(goodsCategories)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveGoodsCategories() -> [ProductCategory] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([ProductCategory].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
