//
//  MockNetworkService.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 25/06/2024.
//

import Foundation
@testable import Shopify

class NetworkServiceMock {
    var result: Result<Any, Error>?

    
    func requestFunction<T>(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        if let result = result {
            completion(result as! Result<T, Error>) // Cast to Result<T, Error>
        }
    }
}
