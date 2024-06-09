//
//  NetworkServiceAuthenticationProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.
//

import Foundation

protocol NetworkServiceAuthenticationProtocol {

    func postCustomerData(customer: [String:Any], completion: @escaping (Result<CustomersModelResponse, Error>) -> Void)
}
