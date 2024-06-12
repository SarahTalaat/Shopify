//
//  NetworkServiceAuthenticationProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.
//

import Foundation

protocol NetworkServiceAuthenticationProtocol {
    func requestFunction<T: Decodable>(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void)

}


