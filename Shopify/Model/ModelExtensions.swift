//
//  ModelExtensions.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 25/06/2024.
//

import Foundation
extension OneDraftOrderResponseDetails {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id as Any,
            "note": note as Any,
            "email": email as Any,
            "taxes_included": taxesIncluded as Any,
            "currency": currency as Any,
            "invoice_sent_at": invoiceSentAt as Any,
            "created_at": createdAt as Any,
            "updated_at": updatedAt as Any,
            "tax_exempt": taxExempt as Any,
            "completed_at": completedAt as Any,
            "name": name as Any,
            "status": status as Any,
            "total_price": totalPrice,
            "subtotal_price": subtotalPrice,
            "total_tax": totalTax as Any,
            "payment_terms": paymentTerms as Any,
            "admin_graphql_api_id": adminGraphqlApiId as Any
        ]

        dictionary["line_items"] = lineItems.map { $0.toDictionary() }
        dictionary["tax_lines"] = taxLines?.map { $0.toDictionary() }
        dictionary["shipping_address"] = shippingAddress as Any
        dictionary["billing_address"] = billingAddress as Any
        dictionary["invoice_url"] = invoiceUrl as Any
        dictionary["applied_discount"] = appliedDiscount as Any
        dictionary["order_id"] = orderId as Any
        dictionary["shipping_line"] = shippingLine as Any
        dictionary["note_attributes"] = noteAttributes as Any

        return dictionary
    }
}

extension LineItem {
    func toDictionary() -> [String: Any] {
        return [
            "id": id as Any,
            "variant_id": variantId as Any,
            "product_id": productId as Any,
            "title": title,
            "variant_title": variantTitle as Any,
            "sku": sku as Any,
            "vendor": vendor as Any,
            "quantity": quantity,
            "requires_shipping": requiresShipping as Any,
            "taxable": taxable as Any,
            "gift_card": giftCard as Any,
            "fulfillment_service": fulfillmentService as Any,
            "grams": grams as Any,
            "tax_lines": taxLines?.map { $0.toDictionary() },
            "applied_discount": appliedDiscount as Any,
            "name": name as Any,
            "properties": properties as Any,
            "custom": custom as Any,
            "price": price,
            "admin_graphql_api_id": adminGraphqlApiId as Any
        ]
    }
}

extension TaxLine {
    func toDictionary() -> [String: Any] {
        return [
            "rate": rate as Any,
            "title": title as Any,
            "price": price as Any
        ]
    }
}
