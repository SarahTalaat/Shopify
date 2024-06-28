//
//  CustomerData.swift
//  Shopify
//
//  Created by Sara Talat on 11/06/2024.
//

import Foundation

struct CustomerData: Equatable {
    let customerId: String
    let name: String
    let email: String
    let favouriteId: String
    let shoppingCartId: String
    
    static func == (lhs: CustomerData, rhs: CustomerData) -> Bool {
        return lhs.customerId == rhs.customerId &&
            lhs.name == rhs.name &&
            lhs.email == rhs.email &&
            lhs.favouriteId == rhs.favouriteId &&
            lhs.shoppingCartId == rhs.shoppingCartId
    }

}
