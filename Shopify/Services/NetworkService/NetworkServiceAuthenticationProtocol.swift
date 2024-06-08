//
//  NetworkServiceAuthenticationProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.
//

import Foundation

protocol NetworkServiceAuthenticationProtocol {
    func postCustomerData(customer: CustomerRequest, completion: @escaping (Swift.Result<CustomerModelResponse, Error>) -> Void)
}
