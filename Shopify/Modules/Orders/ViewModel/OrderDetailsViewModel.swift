//
//  OrderDetailsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation
class OrderDetailsViewModel{
    
    var id: Int = 0 {
        didSet {
            getOrderById()
        }
    }
    
    var src : String = ""
    
    
    var orders: [LineItemss] = [] {
        didSet {
            bindOrders()
        }
    }
    
    var bindOrders: (() -> ()) = {}
    
    init() {
        getOrderById()
    }
    
//    func getProductById(){
//        NetworkUtilities.fetchData(responseType: Product.self, endpoint: "produc", completion: <#T##(T?) -> Void#>)
//    }
//    
    func getOrderById(){
        NetworkUtilities.fetchData(responseType: OrdersSend.self, endpoint: "orders/\(id).json"){ order in
            self.orders = order?.order.line_items ?? []
            
            
        }
        print(id)
    }
    
   
}
