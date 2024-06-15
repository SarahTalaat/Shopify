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
    var shoppingCartId: String?{
        didSet {
            print("SharedDataRepository: shoppingCartId Set: \(String(describing: shoppingCartId))")
            NotificationCenter.default.post(name: .shoppingCartIdDidUpdate, object: nil)
        }
    }
    var favouriteId: String?
    var isSignedIn: Bool = false
}


extension Notification.Name {
    static let shoppingCartIdDidUpdate = Notification.Name("shoppingCartIdDidUpdate")
}


/*
 Changes for merge
 */
