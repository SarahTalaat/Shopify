//
//  OrderDetailsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation
class OrderDetailsViewModel {
    
    var id: Int = 0 {
        didSet {
            getOrderById()
        }
    }
    
    var currency: String = "USD" {
        didSet {
            bindCurrency()
        }
    }
    
    var orders: [LineItem] = [] {
        didSet {
            bindFilteredProducts()
        }
    }
    
    var products: [Products] = [] {
        didSet {
            bindFilteredProducts()
        }
    }
    
    private let networkService = NetworkServiceAuthentication()
    var bindOrders: (() -> Void) = {}
    var bindCurrency: (() -> Void) = {}
    var bindFilteredProducts: (() -> Void) = {}
    
    init() {
        getOrderById()
    }
    
    func getOrderById() {
        NetworkUtilities.fetchData(responseType: OrdersSend.self, endpoint: "orders/\(id).json") { order in
            self.orders = order?.order.line_items ?? []
            self.bindOrders()
        }
    }
    
    func getProducts(productId: Int, completion: @escaping (Products?) -> Void) {
        NetworkUtilities.fetchData(responseType: SingleProduct.self, endpoint: "products/\(productId).json") { SingleProduct in
            completion(SingleProduct?.product)
        }
    }
}
