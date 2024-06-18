//
//  OrdersViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation
class OrdersViewModel{
    
    var orders: [Orders] = [] {
        didSet {
            bindAllOrders()
        }
    }
    
    var bindAllOrders: (() -> ()) = {}
    
    init() {
        getOrders()
    }
    
    func getOrders() {
            guard let email = SharedDataRepository.instance.customerEmail else {
                print("Customer email is nil")
                return
            }
            
            NetworkUtilities.fetchData(responseType: OrdersResponse.self, endpoint: "orders.json") { item in
                if let allOrders = item?.orders {
                    self.orders = allOrders.filter { $0.email == email }
                } else {
                    self.orders = []
                }
                print(self.orders)
            }
        }
     
}

