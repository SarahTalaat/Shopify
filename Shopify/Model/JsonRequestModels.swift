//
//  JsonRequestModels.swift
//  Shopify
//
//  Created by Sara Talat on 12/06/2024.
//

import Foundation




class JsonRequestModels {
    static let instance = JsonRequestModels()
    private init() {}
    
    
    func oneCustomerRequest(verifiedEmail:Bool, email:String, firstName: String)->[String:Any]{
        let createCustomer: [String: Any] = [
            "customer": [
                "verified_email": verifiedEmail,
                "email": email,
                "first_name": firstName
            ]
        ]
        return createCustomer
    }
    
    func draftOrderForShoppingCart(variantId: Int , quantity: Int)->[String:Any]{
        let draftOrder: [String: Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": variantId,
                        "quantity": quantity
                    ]
                ]
            ]
        ]
        return draftOrder
    }
    
    func draftOrderForFavourite(variantId: Int , quantity: Int)->[String:Any]{
        let draftOrder: [String:Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": variantId,
                        "quantity": quantity
                    ]
                ]
            ]
        ]
        return draftOrder
    }
    
}
/*
 44382096457889
 44382094393505
 */
