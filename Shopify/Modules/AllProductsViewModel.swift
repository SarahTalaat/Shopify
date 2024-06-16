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
    
    func productIndexPath(index: Int) {
         print("CategoryViewModel: category vm index: \(index)")
         let product = products[index]
        UserDefaults.standard.set(product.id, forKey: Constants.productId)

    }
    

    
}
