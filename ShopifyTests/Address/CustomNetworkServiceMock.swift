//
//  CustomNetworkServiceMock.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 28/06/2024.
//

import Foundation
@testable import Shopify
enum NetworkError: Error {
    case noData
  
}

class CustomNetworkServiceMock: NetworkServiceAuthentication {
    var result: Result<Data, Error>?

    override func requestFunction<T>(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let result = result else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        switch result {
        case .success(let data):
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
