//
//  OrderDetailsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 12/06/2024.
//

import Foundation
class OrderDetailsViewModel{
    
    var ids: [Int] = []
    
    var products: [Products] = [] {
        didSet {
            bindProducts()
        }
    }
    

    var bindProducts: (() -> ()) = {}
    
    init() {
        getProductsById()
    }
    
    func getProductsById() {
        for i in ids{
            NetworkUtilities.fetchData(responseType: Products.self, endpoint: "products/\(ids).json") { item in
                guard let item = item else {return}
                self.products.append(item)
            }
            print(products)
        }
   
    }
    
}
