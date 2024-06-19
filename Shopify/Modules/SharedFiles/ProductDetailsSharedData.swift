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
    var productVariantId: Int? {
        didSet {
            print("ProductDetailsSharedData: productVariantId Set: \(String(describing: productVariantId))")
            NotificationCenter.default.post(name: .productVariantIdDidUpdate, object: nil)
        }
    }
    
    var filteredProducts: [Products]?
    var filteredSearch: [Products]?

    var brandsProductIndex: Int?
    var screenName: String?
    
}

extension Notification.Name {
    static let filteredCategoryDidUpdate = Notification.Name("filteredCategoryDidUpdate")
}

extension Notification.Name {
    static let productVariantIdDidUpdate = Notification.Name("productVariantIdDidUpdate")
}
