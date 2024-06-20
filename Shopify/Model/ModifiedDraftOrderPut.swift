//
//  ModifiedDraftOrderPut.swift
//  Shopify
//
//  Created by Sara Talat on 15/06/2024.
//

import Foundation

//
//struct DraftOrderResponsePutResponse: Codable {
//    let draftOrder: DraftOrderDetailsResponsePut?
//
//    enum CodingKeys: String, CodingKey {
//        case draftOrder = "draft_order"
//    }
//}
//
//struct DraftOrderDetailsResponsePut: Codable {
//    let id: Int?
//    let note: String?
//    let email: String?
//    let taxesIncluded: Bool?
//    let currency: String?
//    let invoiceSentAt: String?
//    let createdAt: String?
//    let updatedAt: String?
//    let taxExempt: Bool?
//    let completedAt: String?
//    let name: String?
//    let status: String?
//    let lineItems: [LineItemResponsePut2]?
//    let shippingAddress: String? // You can define a proper structure for address if needed
//    let billingAddress: String? // You can define a proper structure for address if needed
//    let invoiceUrl: String?
//    let appliedDiscount: String? // You can define a proper structure for discount if needed
//    let orderId: Int?
//    let shippingLine: String? // You can define a proper structure for shipping line if needed
//    let taxLines: [TaxLineResponsePut2]?
//    let tags: String?
//    let noteAttributes: [NoteAttributeResponsePut]?
//    let totalPrice: String?
//    let subtotalPrice: String?
//    let totalTax: String?
//    let paymentTerms: String? // You can define a proper structure for payment terms if needed
//    let adminGraphqlApiId: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, note, email, currency, name, status, lineItems, taxLines, tags, noteAttributes
//        case taxesIncluded = "taxes_included"
//        case invoiceSentAt = "invoice_sent_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case taxExempt = "tax_exempt"
//        case completedAt = "completed_at"
//        case shippingAddress = "shipping_address"
//        case billingAddress = "billing_address"
//        case invoiceUrl = "invoice_url"
//        case appliedDiscount = "applied_discount"
//        case orderId = "order_id"
//        case shippingLine = "shipping_line"
//        case totalPrice = "total_price"
//        case subtotalPrice = "subtotal_price"
//        case totalTax = "total_tax"
//        case paymentTerms = "payment_terms"
//        case adminGraphqlApiId = "admin_graphql_api_id"
//    }
//}
//
//struct LineItemResponsePut2: Codable {
//    let id: Int?
//    let variantId: Int?
//    let productId: Int?
//    let title: String?
//    let variantTitle: String?
//    let sku: String?
//    let vendor: String?
//    let quantity: Int?
//    let requiresShipping: Bool?
//    let taxable: Bool?
//    let giftCard: Bool?
//    let fulfillmentService: String?
//    let grams: Int?
//    let taxLines: [TaxLineResponsePut2]?
//    let appliedDiscount: String? // You can define a proper structure for discount if needed
//    let name: String?
//    let properties: [String]? // You can define a proper structure for properties if needed
//    let custom: Bool?
//    let price: String?
//    let adminGraphqlApiId: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, sku, vendor, quantity, taxLines, name, properties, custom, price
//        case variantId = "variant_id"
//        case productId = "product_id"
//        case variantTitle = "variant_title"
//        case requiresShipping = "requires_shipping"
//        case taxable, giftCard, fulfillmentService, grams
//        case appliedDiscount = "applied_discount"
//        case adminGraphqlApiId = "admin_graphql_api_id"
//    }
//}
//
//struct TaxLineResponsePut2: Codable {
//    let rate: Float?
//    let title: String?
//    let price: String?
//}
//
//struct NoteAttributeResponsePut: Codable {
//    // Define structure based on your needs
//}


struct DraftOrderResponsePUT: Codable {
    let draftOrder: DraftOrderDetailsPUT?

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderDetailsPUT: Codable {
    let id: Int?
    let note: String?
    let email: String?
    let taxesIncluded: Bool?
    let currency: String?
    let invoiceSentAt: String? // This should ideally be Date if possible
    let createdAt: String? // This should ideally be Date if possible
    let updatedAt: String? // This should ideally be Date if possible
    let taxExempt: Bool?
    let completedAt: String? // This should ideally be Date if possible
    let name: String?
    let status: String?
    let lineItems: [LineItemPUT]?
    let shippingAddress: String? // Define a struct if you have detailed address info
    let billingAddress: String? // Define a struct if you have detailed address info
    let invoiceUrl: String? // URL string for invoice
    let appliedDiscount: String? // Define a Discount struct if needed
    let orderId: Int? // Int or String based on your needs
    let shippingLine: String? // Define a ShippingLine struct if needed
    let taxLines: [TaxLinePUT]?
    let tags: String?
    let noteAttributes: [String]? // Define a NoteAttribute struct if needed
    let totalPrice: String?
    let subtotalPrice: String?
    let totalTax: String?
    let paymentTerms: String? // Define a PaymentTerms struct if needed
    let adminGraphqlApiId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case note
        case email
        case taxesIncluded = "taxes_included"
        case currency
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case name
        case status
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceUrl = "invoice_url"
        case appliedDiscount = "applied_discount"
        case orderId = "order_id"
        case shippingLine = "shipping_line"
        case taxLines = "tax_lines"
        case tags
        case noteAttributes = "note_attributes"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case paymentTerms = "payment_terms"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct LineItemPUT: Codable {
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
    let taxLines: [TaxLinePUT]?
    let appliedDiscount: String? // Define a Discount struct if needed
    let name: String?
    let properties: [String]? // Define a Property struct if needed
    let custom: Bool?
    let price: String?
    let adminGraphqlApiId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case variantId = "variant_id"
        case productId = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku
        case vendor
        case quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case taxLines = "tax_lines"
        case appliedDiscount = "applied_discount"
        case name
        case properties
        case custom
        case price
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? NSNull(),
            "variant_id": variantId ?? NSNull(),
            "product_id": productId ?? NSNull(),
            "title": title ?? NSNull(),
            "variant_title": variantTitle ?? NSNull(),
            "sku": sku ?? NSNull(),
            "vendor": vendor ?? NSNull(),
            "quantity": quantity ?? NSNull(),
            "requires_shipping": requiresShipping ?? NSNull(),
            "taxable": taxable ?? NSNull(),
            "gift_card": giftCard ?? NSNull(),
            "fulfillment_service": fulfillmentService ?? NSNull(),
            "grams": grams ?? NSNull(),
            "tax_lines": taxLines?.map { $0.toDictionary() } ?? NSNull(),
            "applied_discount": appliedDiscount ?? NSNull(),
            "name": name ?? NSNull(),
            "properties": properties ?? NSNull(),
            "custom": custom ?? NSNull(),
            "price": price ?? NSNull(),
            "admin_graphql_api_id": adminGraphqlApiId ?? NSNull()
        ]
    }
}

struct TaxLinePUT: Codable {
    let rate: Double?
    let title: String?
    let price: String?

    enum CodingKeys: String, CodingKey {
        case rate
        case title
        case price
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "rate": rate ?? NSNull(),
            "title": title ?? NSNull(),
            "price": price ?? NSNull()
        ]
    }
}
