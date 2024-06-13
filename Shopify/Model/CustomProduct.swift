//
//  CustomProduct.swift
//  Shopify
//
//  Created by Sara Talat on 13/06/2024.
//

import Foundation


struct CustomProduct {
    var productId: String
    var productTitle: String
    var productSize: String
    var productColour: String
    var productImage: String
    
    init(productId: String, productTitle: String, productSize: String, productColour: String, productImage: String) {
        self.productId = productId
        self.productTitle = productTitle
        self.productSize = productSize
        self.productColour = productColour
        self.productImage = productImage
    }
}
