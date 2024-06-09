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

/*
 store url : mad44-alex-ios-team4.myshopify.com
 admin api access token : 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
 api key : b67adf5ce29253f64d89943674815b12
 api secret key : 2f9f8ee83ca8dfa66cd19e60d5514cbc
 resource : customers

 https://{apikey}:{password}@{hostname}/admin/api/{version}/{resource}.json

 */
