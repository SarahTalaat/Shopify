//
//  OneProductResponseFromApi.swift
//  Shopify
//
//  Created by Sara Talat on 17/06/2024.
//
import Foundation

struct ProductResponseFromApi: Codable {
    let product: ProductFromApi?
}

struct ProductFromApi: Codable {
    let id: Int?
    let title: String?
    let body_html: String?
    let vendor: String?
    let product_type: String?
    let created_at: String?
    let handle: String?
    let updated_at: String?
    let published_at: String?
    let template_suffix: String?
    let published_scope: String?
    let tags: String?
    let status: String?
    let admin_graphql_api_id: String?
    let variants: [VariantFromApi]?
    let options: [OptionFromApi]?
    let images: [ImageFromApi]?
    let image: ImageFromApi?
}

struct VariantFromApi: Codable {
    let product_id: Int?
    let id: Int?
    let title: String?
    let price: String?
    let sku: String?
    let position: Int?
    let inventory_policy: String?
    let compare_at_price: String?
    let fulfillment_service: String?
    let inventory_management: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let created_at: String?
    let updated_at: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let weight: Int?
    let weight_unit: String?
    let inventory_item_id: Int?
    let inventory_quantity: Int?
    let old_inventory_quantity: Int?
    let requires_shipping: Bool?
    let admin_graphql_api_id: String?
    let image_id: Int?
}

struct OptionFromApi: Codable {
    let product_id: Int?
    let id: Int?
    let name: String?
    let position: Int?
    let values: [String]?
}

struct ImageFromApi: Codable {
    let id: Int?
    let alt: String?
    let position: Int?
    let product_id: Int?
    let created_at: String?
    let updated_at: String?
    let admin_graphql_api_id: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variant_ids: [Int]?
}

