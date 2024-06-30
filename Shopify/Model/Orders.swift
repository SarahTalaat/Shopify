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
    let order_number : Int?
    let created_at: String?
    let currency: String
    let email: String?
    let total_price: String?
    let total_discounts: String?
    let total_tax: String?
    let line_items: [LineItem]
    let inventory_behaviour :String?
    let subtotal_price : String?
    let total_outstanding: String?
    let current_total_discounts : String?
    let send_receipt : Bool?
    
    
}


struct CountResponse: Codable {
    let count: Int
}

struct InvoiceResponse : Encodable,Decodable{
    let draft_order_invoice : Invoice
}


struct Invoice : Encodable,Decodable{
   let `to`: String
   let `from` : String
   let subject: String
   let custom_message : String
   let line_items: [LineItem]
}


