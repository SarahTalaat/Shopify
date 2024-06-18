//
//  OneDraftOrderResponse.swift
//  Shopify
//
//  Created by Sara Talat on 12/06/2024.
//

import Foundation


struct OneDraftOrderResponse: Codable {
    var draftOrder: OneDraftOrderResponseDetails?

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct OneDraftOrderResponseDetails: Codable {
    let id: Int?
    let note: String?
    let email: String?
    let taxesIncluded: Bool?
    let currency: String?
    let invoiceSentAt: String?
    let createdAt: String?
    let updatedAt: String?
    let taxExempt: Bool?
    let completedAt: String?
    let name: String?
    let status: String?
    var lineItems: [LineItem]
    let shippingAddress: String?
    let billingAddress: String?
    let invoiceUrl: String?
    let appliedDiscount: String?
    let orderId: Int?
    let shippingLine: String?
    let taxLines: [TaxLine]?
    let tags: String?
    let noteAttributes: [String]?
    let totalPrice: String
    let subtotalPrice: String
    let totalTax: String?
    let paymentTerms: String?
    let adminGraphqlApiId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, note, email, currency, name, status, tags
        case taxesIncluded = "taxes_included"
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceUrl = "invoice_url"
        case appliedDiscount = "applied_discount"
        case orderId = "order_id"
        case shippingLine = "shipping_line"
        case taxLines = "tax_lines"
        case noteAttributes = "note_attributes"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case paymentTerms = "payment_terms"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct LineItem: Codable {
    let id: Int?
    let variantId: Int?
    let productId: Int?
    let title: String
    let variantTitle: String?
    let sku: String?
    let vendor: String?
    var quantity: Int
    let requiresShipping: Bool?
    let taxable: Bool?
    let giftCard: Bool?
    let fulfillmentService: String?
    let grams: Int?
    let taxLines: [TaxLine]?
    let appliedDiscount: String?
    let name: String?
    let properties: [String]?
    let custom: Bool?
    let price: String
    let adminGraphqlApiId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, sku, vendor, quantity, grams, name, properties, custom, price
        case variantId = "variant_id"
        case productId = "product_id"
        case variantTitle = "variant_title"
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case taxLines = "tax_lines"
        case appliedDiscount = "applied_discount"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct TaxLine: Codable {
    let rate: Double?
    let title: String?
    let price: String?
}
