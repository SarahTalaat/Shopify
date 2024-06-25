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
    
    var currency: String = "USD"{
        didSet {
            bindCurrency()
        }
    }
    var orders: [LineItem] = [] {
        didSet {
            getProducts()
        }
    }

    var products: [Products] = []  {
        didSet{
            filterProductsByLineItems()
        }
    }
    
    var filteredProducts: [Products] = [] {
         didSet {
             bindOrders()
         }
     }
    
    private let networkService = NetworkServiceAuthentication()
    var bindOrders: (() -> ()) = {}
    var bindCurrency: (() -> ()) = {}
    var bindFilteredProducts: (() -> ()) = {}

    init() {
        getOrderById()
    }
 
    func getOrderById(){
         NetworkUtilities.fetchData(responseType: OrdersSend.self, endpoint: "orders/\(id).json"){ order in
             self.orders = order?.order.line_items ?? []
             
         }
         print(id)
     }
     
     func getProducts() {
         NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json") { product in
             self.products = product?.products ?? []
         }
     }
     
    func filterProductsByLineItems() {
        let lineItemTitles = orders.map { $0.title }
        filteredProducts = products.filter { product in
            return lineItemTitles.contains(product.title)
        }
        print(filteredProducts)
    }
    
   
}
