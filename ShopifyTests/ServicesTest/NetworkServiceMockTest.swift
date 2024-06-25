//
//  NetworkServiceMockTest.swift
//  ShopifyTests
//
//  Created by Sara Talat on 24/06/2024.
//


import Foundation
import Alamofire

import Shopify

enum NetworkError: Error {
    case networkError
}

protocol NetworkServiceProtocol {
    func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Swift.Result<String, NetworkError>) -> Void)
}

class MockNetworkService: NetworkServiceProtocol {

    var shouldReturnError = false

    func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Swift.Result<String, NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.networkError))
        } else {
            // Simulate success with mock data
            completion(.success("Mock data"))
        }
    }
}
