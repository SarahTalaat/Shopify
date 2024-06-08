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
            updatePrice()
        }
    }
    
    var productsPrice :[String] = []
    var bindProducts : (() -> ()) = {}
    
    
    init(){
        getProducts()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json?collection_id=\(brandID)") { product in
            self.products = product?.products ??  []
        }
    }
    
    func updatePrice(){
        productsPrice = products.flatMap { product in
            product.variants.map { variant in
                variant.price
            }
        }
        print(productsPrice)
    }
    
    func filterByPrice(maxPrice: Float) -> [Products] {
        return products.filter { product in
            product.variants.contains { variant in
                if let variantPrice = Float(variant.price) {
                    return variantPrice <= maxPrice
                }
                return false
            }
        }
    }
}
