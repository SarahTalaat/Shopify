//
//  ExchangeRatesResponse.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 14/06/2024.
//

import Foundation
struct ExchangeRatesResponse: Codable {
    let base_code: String
    let conversion_rates: [String: Double]
}
