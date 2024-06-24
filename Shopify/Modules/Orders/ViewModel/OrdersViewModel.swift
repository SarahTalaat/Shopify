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
    private let networkService = NetworkServiceAuthentication()

    init() {
        getOrders()
    }
    
    func getOrders() {
          guard let email = SharedDataRepository.instance.customerEmail else {
              print("Customer email is nil")
              return
          }

          let urlString = APIConfig.endPoint("orders").url
          networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<OrdersResponse, Error>) in
              switch result {
              case .success(let response):
                  self.orders = response.orders.filter { $0.email == email }
              case .failure(let error):
                  print("Failed to fetch orders: \(error.localizedDescription)")
                  self.orders = []
              }
              self.bindAllOrders()
              print(self.orders)
          }
      }
  }
     


