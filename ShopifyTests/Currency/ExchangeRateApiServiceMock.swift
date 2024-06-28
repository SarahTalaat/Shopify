//
//  ExchangeRateApiServiceMock.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 28/06/2024.
//

import Foundation
@testable import Shopify
class ExchangeRateApiServiceMock: ExchangeRateApiService {
    enum MockResponse {
        case success(ExchangeRatesResponse)
        case failure(Error)
    }
    
    var mockResponse: MockResponse = .success(ExchangeRatesResponse(base_code: "USD", conversion_rates: ["USD": 1.0, "EGP": 18.0]))
    
    override func getLatestRates(completion: @escaping (Result<ExchangeRatesResponse, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { // Simulate network delay
            print("ExchangeRateApiServiceMock: getLatestRates called")
            switch self.mockResponse {
            case .success(let response):
                print("ExchangeRateApiServiceMock: returning success")
                completion(.success(response))
            case .failure(let error):
                print("ExchangeRateApiServiceMock: returning failure")
                completion(.failure(error))
            }
        }
    }
}

enum MockError: Error {
    case someError
}
