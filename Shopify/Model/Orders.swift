//
//  Orders.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation

    struct OrdersResponse:Encodable{
        let order : Orders
    }

    struct Orders: Encodable{

            let id: Int
            let confirmation_number: String
            let confirmed: Bool
            let created_at: String
            let currency: String
            let email: String
            let financial_status:String
            let order_number: Int
            let presentment_currency: String
            let source_name: String
            let tags: String
            let token: String
            let total_discounts: String
            let total_line_items_price: String
            let total_price: String
            let line_items : [LineItemss]
    }

    struct LineItemss:Encodable{
        
            let id : Int
            let name: String
            let price: String
            let price_set: ShopMoney
            let quantity: Int
            let title: String
            let total_discount: String
            let total_discount_set:ShopMoney
    }

    struct ShopMoney:Encodable{
        let amount:String
        let currency_code: String
    }


   




