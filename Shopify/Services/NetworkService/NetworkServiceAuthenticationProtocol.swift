//
//  NetworkServiceAuthenticationProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.
//

import Foundation

protocol NetworkServiceAuthenticationProtocol {
    func postFunction<T: Decodable>(urlString: String, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void)
}
