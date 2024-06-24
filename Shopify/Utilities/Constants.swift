//
//  Constants.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation

class Constants  {

    static let apiKey = "b67adf5ce29253f64d89943674815b12"
    static let adminApiAccessToken = "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"
    static let version = "2022-01"
    static let password = "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"
    static let credentials = "\(apiKey):\(password)"
    
    static let shoppingCartId: String = "shoppingCartId"
    static let variantId: String = "variantId"
    
    static let productId: String = "productId"
    static let productTitle: String = "productTitle"
    static let productVendor: String = "productVendor"
    static let productImage: String = "productImage"
    static let customerEmail: String = "customerEmail"
    static let isFavoritedKey: String = "isFavoritedKey"
    
    static let draftOrderId: String = "draftOrderId"
    static let userDraftId: String = "userDraftId"
    static let customerId: String = "customerId"
    
    static let onboardingKey = "hasSeenOnboarding"
    static let inventoryQuantity = "inventoryQuantity"
    
    let apiKeyExchangeRates = "b1b362324215ea59af2d3263"
    let baseUrlExchangeRates = "https://v6.exchangerate-api.com/v6/"
    lazy var exchangeRatesUrl: String = {
        return "\(baseUrlExchangeRates)\(apiKeyExchangeRates)/latest/USD"
    }()
}



enum APIConfig {
    static let apiKey = "b67adf5ce29253f64d89943674815b12"
    static let password = "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"
    static let hostName = "mad44-alex-ios-team4.myshopify.com"
    static let version = "2022-01"
    static let apiKey2 = "b1b362324215ea59af2d3263"
    static let baseUrl2 = "https://v6.exchangerate-api.com/v6/"
    
    
    case draft_orders
    case customers
    case usd
    case endPoint(String)
    case all
    
    var resource: String {
        switch self {
        case .draft_orders:
            return "draft_orders"
        case .customers:
            return "customers"
        case .usd:
            return "USD"
        case .all:
            return "ALL"
        case .endPoint(let customResource):
            return customResource
        }
    }
    
    var url: String {
        return "https://\(APIConfig.apiKey):\(APIConfig.password)@\(APIConfig.hostName)/admin/api/\(APIConfig.version)/\(self.resource).json"
    }
    
    var url2: String {
        return "\(APIConfig.baseUrl2)\(APIConfig.apiKey2)/latest/\(self.resource)"
    }
    
    var credentials: String {
        return "\(APIConfig.apiKey):\(APIConfig.password)"
    }
}

/*
 store url : mad44-alex-ios-team4.myshopify.com
 admin api access token : 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
 api key : b67adf5ce29253f64d89943674815b12
 api secret key : 2f9f8ee83ca8dfa66cd19e60d5514cbc
 resource : customers

 https://{apikey}:{password}@{hostname}/admin/api/{version}/{resource}.json

 */
