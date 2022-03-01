//
//  Controllers.swift
//  
//
//  Created by Home on 01.03.2022.
//

import Foundation

protocol Controllers {    
}

extension Controllers {
    func getPage<T>(page: Int, allItems: [T], maxItemsPerPage: Int) -> [T] {
        let startIndex = Int(page * maxItemsPerPage)
        var length = max(0, allItems.count - startIndex)
        length = min(Int(maxItemsPerPage), length)
        guard length > 0 else { return allItems }
        return Array(allItems[startIndex..<(startIndex + length)])
    }
}
