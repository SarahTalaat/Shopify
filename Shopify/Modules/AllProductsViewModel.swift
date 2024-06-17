//
//  AllProductsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 11/06/2024.
//

import Foundation


class AllProductsViewModel{
    
    var products: [Products] = [] {
        didSet {
            ProductDetailsSharedData.instance.filteredSearch = products
            bindAllProducts()
            
        }
    }
    

    var bindAllProducts: (() -> ()) = {}
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json") { product in
            self.products = product?.products ?? []

        }
    }
    
    func addValueToUserDefaults(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getproductId(index: Int){
        var productId = products[index].id
        addValueToUserDefaults(value: productId, forKey: Constants.productId)
    }
}
