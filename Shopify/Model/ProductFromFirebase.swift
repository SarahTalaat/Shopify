//
//  ProductFromFirebase.swift
//  Shopify
//
//  Created by Sara Talat on 16/06/2024.
//

import Foundation

struct ProductFromFirebase: Equatable {
    let productId: String
    let productTitle: String
    let productVendor: String
    let productImage: String
    
    static func == (lhs: ProductFromFirebase, rhs: ProductFromFirebase) -> Bool {
        return lhs.productId == rhs.productId && lhs.productTitle == rhs.productTitle && lhs.productVendor == rhs.productVendor && lhs.productImage == rhs.productImage
    }
}

