//
//  NetworkServiceAuthenticationProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.
//

import Foundation

protocol NetworkServiceAuthenticationProtocol {
    func postCustomerData<T: Decodable>(apiConfig: APIConfig, customer: [String: Any], completion: @escaping (Result<T, Error>) -> Void) 
}
