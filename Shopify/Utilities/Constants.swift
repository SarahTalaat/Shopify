//
//  Constants.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation

class Constants  {
    
}


enum APIConfig {
    static let apiKey = "b67adf5ce29253f64d89943674815b12"
    static let password = "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"
    static let hostName = "mad44-alex-ios-team4.myshopify.com"
    static let version = "2022-01"
    
    case customers
    case customer
    case endPoint(String)
    
    var resource: String {
        switch self {
        case .customers:
            return "customers"
        case .customer:
            return "customer"
        case .endPoint(let customResource):
            return customResource
        }
    }
    
    var url: String {
        return "https://\(APIConfig.apiKey):\(APIConfig.password)@\(APIConfig.hostName)/admin/api/\(APIConfig.version)/\(self.resource).json"
    }
}

