//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class ProductViewModel{
    
    var brandID : Int =  0 {
        didSet{
            getProducts()
        }
    }
    var products : [Products] = []{
        didSet{
            bindProducts()
        }
    }
    
    var bindProducts : (() -> ()) = {}
    
    init(){
        getProducts()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json?collection_id=\(brandID)") { product in
            self.products = product?.products ??  []
          }
      }
}
