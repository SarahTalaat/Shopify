//
//  ModifiedDraftOrderPut.swift
//  Shopify
//
//  Created by Sara Talat on 15/06/2024.
//

import Foundation


struct DraftOrderResponsePutResponse: Codable {
    let draftOrder: DraftOrderDetailsPutResponsePut?
    
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderDetailsPutResponsePut: Codable {
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
    let lineItems: [LineItemResponsePut]?
    let shippingAddress: String? // You can define a proper structure for address if needed
    let billingAddress: String? // You can define a proper structure for address if needed
    let invoiceUrl: String?
    let appliedDiscount: String? // You can define a proper structure for discount if needed
    let orderId: Int?
    let shippingLine: String? // You can define a proper structure for shipping line if needed
    let taxLines: [TaxLineResponsePut]?
    let tags: String?
    let noteAttributes: [NoteAttributeResponsePut]?
    let totalPrice: String?
    let subtotalPrice: String?
    let totalTax: String?
    let paymentTerms: String? // You can define a proper structure for payment terms if needed
    let adminGraphqlApiId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, note, email, currency, name, status, lineItems, taxLines, tags, noteAttributes
        case taxesIncluded = "taxes_included"
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceUrl = "invoice_url"
        case appliedDiscount = "applied_discount"
        case orderId = "order_id"
        case shippingLine = "shipping_line"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case paymentTerms = "payment_terms"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct LineItemResponsePut: Codable {
    let id: Int?
    let variantId: Int?
    let productId: Int?
    let title: String?
    let variantTitle: String?
    let sku: String?
    let vendor: String?
    let quantity: Int?
    let requiresShipping: Bool?
    let taxable: Bool?
    let giftCard: Bool?
    let fulfillmentService: String?
    let grams: Int?
    let taxLines: [TaxLineResponsePut]?
    let appliedDiscount: String? // You can define a proper structure for discount if needed
    let name: String?
    let properties: [String]? // You can define a proper structure for properties if needed
    let custom: Bool?
    let price: String?
    let adminGraphqlApiId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, sku, vendor, quantity, taxLines, name, properties, custom, price
        case variantId = "variant_id"
        case productId = "product_id"
        case variantTitle = "variant_title"
        case requiresShipping = "requires_shipping"
        case taxable, giftCard, fulfillmentService, grams
        case appliedDiscount = "applied_discount"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct TaxLineResponsePut: Codable {
    let rate: Float?
    let title: String?
    let price: String?
}

struct NoteAttributeResponsePut: Codable {
    // Define structure based on your needs
}
