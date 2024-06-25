//
//   MockNetworkService.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 25/06/2024.
//

import Foundation
@testable import Shopify

class MockNetworkService: NetworkServiceAuthenticationProtocol {
    var result: Result<Any, Error>?
    
    func requestFunction<T: Decodable>(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        if let result = result as? Result<T, Error> {
            completion(result)
        }
    }
}
