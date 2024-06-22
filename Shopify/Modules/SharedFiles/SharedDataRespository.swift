//
//  SharedDataRespository.swift
//  Shopify
//
//  Created by Sara Talat on 11/06/2024.
//

import Foundation

class SharedDataRepository{
    
    private let queue = DispatchQueue(label: "com.Shopify.SharedDataRepository.queue", attributes: .concurrent)
    
    
    static let instance = SharedDataRepository()
    private init() {}
    
    var draftOrderId: String = UserDefaults.standard.string(forKey: Constants.draftOrderId) ?? "NO iddd"
    var customerName: String?
    var customerEmail: String?
    var customerId: String?
    var favouriteId: String?
    var isSignedIn: Bool = false
    
    private var _shoppingCartId: String?
    
    var shoppingCartId: String? {
        get {
            return queue.sync {
                _shoppingCartId
            }
        }
        set {
            queue.async(flags: .barrier) {
                print("xxx SharedDataRepository: setting shoppingCartId to: \(String(describing: newValue))")
                self._shoppingCartId = newValue
                print("xxx SharedDataRepository: shoppingCartId Set: \(String(describing: self._shoppingCartId))")
            }
        }
    }
    
    func getShoppingCartId() -> String? {
        return shoppingCartId
    }
}




/*
 Changes for merge
 */
