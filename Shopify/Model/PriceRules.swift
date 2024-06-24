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

struct DiscountCodeResponse :Encodable,Decodable{
    let discount_code : DiscountCode
}

struct DiscountCode: Codable {
    let price_rule_id: Int
    let code: String
    
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}

struct DiscountResponse :Decodable{
    let discount_codes : [Discount]
}

struct Discount : Decodable{
    let id : Int
    let price_rule_id: Int
    let code: String
}





