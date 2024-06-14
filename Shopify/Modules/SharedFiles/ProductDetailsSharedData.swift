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
    var brandsProductIndex: Int?
    
    
    
    
}
