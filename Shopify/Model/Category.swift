//
//  Category.swift
//  Shopify
//
//  Created by Haneen Medhat on 10/06/2024.
//

import Foundation


struct CategoryResponse : Decodable,Encodable {
    let products : [Product]
}

struct Product : Decodable,Encodable{
    let id : Int
    let title : String
    let body_html : String
    let vendor : String
    let product_type : String
    let image : ImageOf
    let status : String
}

struct ImageOf: Decodable,Encodable{
    let id : Int
    let product_id : Int
    let src : String
}


enum CategoryID: String {
    case men = "303081423009"
    case women = "303081455777"
    case kids = "303081488545"
    case sale = "303081521313"
}

enum SubCategories : String {
    case shoes = "SHOES"
    case cloth = "T-SHIRTS"
    case bag = "ACCESSORIES"
    case all = "ALL"
}
