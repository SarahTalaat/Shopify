//
//  Category.swift
//  Shopify
//
//  Created by Haneen Medhat on 10/06/2024.
//

import Foundation


struct CategoryResponse : Decodable {
    let products : [Product]
}

struct Product : Decodable{
    let id : Int
    let title : String
    let body_html : String
    let vendor : String
    let product_type : String
    let image : ImageOf
    let status : String
}

struct ImageOf: Decodable{
    let id : Int
    let product_id : Int
    let src : String
}
