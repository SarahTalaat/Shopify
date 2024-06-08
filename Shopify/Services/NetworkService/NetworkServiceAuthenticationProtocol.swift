//
//  NetworkServiceAuthenticationProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.
//

import Foundation

protocol NetworkServiceAuthenticationProtocol {
    func postCustomerData(customer: CustomerModelRequest, completion: @escaping (Swift.Result<CustomerModelResponse, Error>) -> Void)
}
