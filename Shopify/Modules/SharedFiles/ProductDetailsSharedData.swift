//
//  ProductDetailsSharedData.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation


class ProductDetailsSharedData {

    static let instance = ProductDetailsSharedData()
    private init() {}
    
    var filteredCategory: ProductModel? {
        didSet {
            print("ProductDetailsSharedData: Filtered Category Set: \(String(describing: filteredCategory))")
            NotificationCenter.default.post(name: .filteredCategoryDidUpdate, object: nil)
        }
    }

    var filteredProducts: [Products]?
//    var filteredCategory: ProductModel?
    var filteredSearch: [Products]?

    
    var brandsProductIndex: Int?
    var screenName: String?
    
    
    
}

extension Notification.Name {
    static let filteredCategoryDidUpdate = Notification.Name("filteredCategoryDidUpdate")
}
