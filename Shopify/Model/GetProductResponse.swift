//
//  GetProductResponse.swift
//  Shopify
//
//  Created by Sara Talat on 16/06/2024.
//

import Foundation


struct GetProductResponse: Codable {
    let product: GetProduct?
}

struct GetProduct: Codable {
    let id: Int64?
    let title: String?
    let bodyHtml: String?
    let vendor: String?
    let productType: String?
    let createdAt: String?
    let handle: String?
    let updatedAt: String?
    let publishedAt: String?
    let templateSuffix: String?
    let publishedScope: String?
    let tags: String?
    let status: String?
    let adminGraphqlApiId: String?
    let variants: [GetVariant]?
    let options: [GetOption]?
    let images: [GetImage]?
    let image: GetImage?
    
    enum CodingKeys: String, CodingKey {
        case id, title, vendor, handle, tags, status, variants, options, images, image
        case bodyHtml = "body_html"
        case productType = "product_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct GetVariant: Codable {
    let id: Int64?
    let productId: Int64?
    let title: String?
    let price: String?
    let sku: String?
    let position: Int?
    let inventoryPolicy: String?
    let compareAtPrice: String?
    let fulfillmentService: String?
    let inventoryManagement: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let createdAt: String?
    let updatedAt: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let weight: Int?
    let weightUnit: String?
    let inventoryItemId: Int64?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let requiresShipping: Bool?
    let adminGraphqlApiId: String?
    let imageId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, sku, position, taxable, barcode, grams, weight
        case option1, option2, option3, requiresShipping, imageId
        case productId = "product_id"
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct GetOption: Codable {
    let id: Int64?
    let productId: Int64?
    let name: String?
    let position: Int?
    let values: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, position, values
        case productId = "product_id"
    }
}

struct GetImage: Codable {
    let id: Int64?
    let alt: String?
    let position: Int?
    let productId: Int64?
    let createdAt: String?
    let updatedAt: String?
    let adminGraphqlApiId: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variantIds: [Int64]?
    
    enum CodingKeys: String, CodingKey {
        case id, alt, position, width, height, src, variantIds
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}
