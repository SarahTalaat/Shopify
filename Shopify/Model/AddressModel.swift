//
//  AddressModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 07/06/2024.
//
 
import Foundation
 
struct Address: Codable {
    let id: Int?
    let first_name: String
    let address1: String
    let city: String
    let country: String
    let zip: String
    var `default`: Bool?
}
 
struct AddressListResponse: Codable {
    let addresses: [Address]
}
 
struct AddressResponse: Codable {
    let customer_address: Address
}

