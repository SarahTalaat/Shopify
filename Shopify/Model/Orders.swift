//
//  Orders.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation

 struct OrdersResponse:Encodable,Decodable{
    let orders : [Orders]
}

struct OrdersSend: Encodable, Decodable {
    let order: Orders
}

struct Orders: Encodable, Decodable {
    let id: Int?
    let created_at: String?
    let currency: String
    let email: String?
    let total_price: String?
    let line_items: [LineItem]
}


struct CountResponse: Codable {
    let count: Int
}

