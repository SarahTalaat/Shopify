//
//  AddCustomer.swift
//  Shopify
//
//  Created by Sara Talat on 10/06/2024.
//

import Foundation

struct CustomerRequest: Codable {
    let first_name: String?
    let email: String?
    let verified_email: Bool?
}

struct CustomerModelRequest: Codable {
    let customer: CustomerRequest
}
