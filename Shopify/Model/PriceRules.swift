//
//  PriceRules.swift
//  Shopify
//
//  Created by Haneen Medhat on 11/06/2024.
//

import Foundation

struct PriceRulesResponse : Decodable{
    let price_rules : [PriceRules]
}

struct PriceRules: Decodable{
    let id : Int
    let value_type: String
    let value: String
    let target_type : String
}

struct DiscountCodeResponse :Encodable{
    let discount_code : DiscountCode
}

struct DiscountCode : Encodable{
    let price_rule_id: Int
    let code: String
}


struct DiscountResponse :Decodable{
    let discount_codes : [Discount]
}

struct Discount : Decodable{
    let id : Int
    let price_rule_id: Int
    let code: String
}


