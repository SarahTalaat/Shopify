//
//  Orders.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation

    struct OrdersResponse:Decodable{
        let orders : [Orders]
    }
    struct OrdersSend:Encodable{
        let order : Orders
    }

    struct Orders: Encodable,Decodable{
            let id: Int
            let confirmation_number: String
            let confirmed: Bool
            let created_at: String
            let currency: String
            let email: String
            let financial_status:String
            let order_number: Int
            let source_name: String
            let tags: String
            let token: String
            let total_discounts: String
            let total_line_items_price: String
            let total_price: String
            let line_items : [LineItemss]
    }

    struct LineItemss:Encodable,Decodable{
            let id : Int
            let name: String
            let price: String
            let quantity: Int
            let title: String
            let total_discount: String
    }


   




