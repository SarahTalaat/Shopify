//
//  SharedDataRespository.swift
//  Shopify
//
//  Created by Sara Talat on 11/06/2024.
//

import Foundation

class SharedDataRepository{
    
    static let instance = SharedDataRepository()
    private init() {}
    
    var customerName: String?
    var customerEmail: String?
    var customerId: String?
    var shoppingCartId: String?
    var favouriteId: String?
    var isSignedIn: Bool?
}
