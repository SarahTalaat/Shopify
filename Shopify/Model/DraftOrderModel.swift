//
//  DraftOrderModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 10/06/2024.
//

import Foundation

struct DraftOrder: Codable  {
    let id: Int
    let email: String?
    let currency: String
    let tax_exempt: Bool
    let status: String
    let shipping_address: Address?
    let applied_discount: Int?
    let order_id: Int?
    let subtotal_price: String
    let total_price: String
    let total_tax: String
    var line_items: [LineItem]
}

struct LineItem: Codable {
    let title: String
    let variant_id: Int
    let variant_title: String
    var quantity: Int
    let price: String
}
