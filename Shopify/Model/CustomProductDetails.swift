//
//  CustomProductDetails.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation

struct CustomProductDetails{
    var images: [String]?
    var colour : [String]?
    var size: [String]?
    var variant : [Variants]?
    var vendor: String?
    var title: String?
    var price: String?
    var description: String?
    
    init(images:[String], colour:[String], size:[String], variant:[Variants], vendor: String, title:String, price:String, description: String){
        self.images = images
        self.colour = colour
        self.size = size
        self.variant = variant
        self.vendor = vendor
        self.title = title
        self.price = price
        self.description = description
    }
    
}
