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
    var isSignedIn: Bool = false
    
    func setShoppingCartId(_ id: String?) {
        print("xxx SharedDataRepository: setting shoppingCartId to: \(String(describing: id))")
        shoppingCartId = id
        print("xxx SharedDataRepository: shoppingCartId Set: \(String(describing: shoppingCartId))")
    }

    func getShoppingCartId() -> String? {
        return shoppingCartId
    }
}




/*
 Changes for merge
 */
