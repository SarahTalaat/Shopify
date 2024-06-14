//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class ProductViewModel{
    
    var brandID: Int = 0 {
        didSet {
            getProducts()
        }
    }
    
    var products: [Products] = [] {
        didSet {
            calculatePriceRange()
            filterProducts()
        }
    }
    
    var filteredProducts: [Products] = [] {
        didSet {
            bindFilteredProducts()
            ProductDetailsSharedData.instance.filteredProducts = filteredProducts
            print(filteredProducts)
        }
    }
    
    var coloredProducts: [Products] = [] {
        didSet {
            bindFilteredProducts()
        }
    }
    var minPrice: Float = 0
    var maxPrice: Float = 1000
    
    var bindFilteredProducts: (() -> ()) = {}
    var bindPriceRange: (() -> ()) = {}
    
    var currentMaxPrice: Float = 1000 {
        didSet {
            filterProducts()
        }
    }
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json?collection_id=\(brandID)") { product in
            self.products = product?.products ?? []
        }
    }
    
    func calculatePriceRange() {
        let prices = products.compactMap { Float($0.variants.first?.price ?? "0") }
        minPrice =  0
        maxPrice = prices.max() ?? 1000
        currentMaxPrice = maxPrice
        bindPriceRange()
    }
    
    func filterProducts() {
        filteredProducts = products.filter { product in
            if let productPrice = Float(product.variants.first?.price ?? "0") {
                return productPrice <= currentMaxPrice
            }
            return false
        }
    }
    
    func filterByColor(color: String) {
        coloredProducts = products.filter { product in
            for option in product.options where option.name == "Color" {
                if option.values.contains(color) {
                    return true
                }
            }
            return false
        }
        filteredProducts = coloredProducts 
    }
    
    func productIndexPath(index: Int){
        print("prod vm index: \(index)")
        ProductDetailsSharedData.instance.brandsProductIndex = index
    }
    
    func screenNamePassing(screenName: String){
        ProductDetailsSharedData.instance.screenName = screenName
    }
 
}
