//
//  Products.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation
struct ProductResponse :Decodable{
  let products : [Products]
}

struct Products: Decodable{
    let id : Int
    let title : String
    let body_html : String
    let vendor : String
    let product_type : String
    let handle : String
    let status : String
    let variants : [Variants]
    let images : [Images]
}

struct Variants:Decodable{
    let id : Int
    let product_id : Int
    let title : String
    let price : String
    let position : Int
    let inventory_policy : String
    let option1 : String
    let option2 : String
    let inventory_item_id : Int
    let inventory_quantity : Int
    let requires_shipping : Bool
}

struct Images : Decodable {
   let id : Int
   let product_id : Int
   let src : String
}


