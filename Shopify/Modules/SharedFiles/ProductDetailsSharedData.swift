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
    
    var filteredProducts: [Products]?
//    var filteredCategory: ProductModel?
    var filteredSearch: [Products]?
    var filteredCategory: ProductModel? {
        get {
            print("filteredCategoryProduct : \(filteredCategory)")
            return filteredCategory
        }
        set {
            filteredCategory = newValue
            print("Filtered Category Set: \(String(describing: filteredCategory))")
        }
    }
    
    var brandsProductIndex: Int?
    var screenName: String?
    
    
    
}
