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
    
    var ids : [Int] = []
    var bindAllOrders: (() -> ()) = {}
    
    init() {
        getOrders()
    }
    
    func getOrders() {
        NetworkUtilities.fetchData(responseType: OrdersResponse.self, endpoint: "orders.json?status=any") { item in
            self.orders = item?.orders ?? []
        }
        print(orders)
    }
    func getIds(index:Int){
        ids = orders[index].line_items.map { $0.id }
    }
     
}

