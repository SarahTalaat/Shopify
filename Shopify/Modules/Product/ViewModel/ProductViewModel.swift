//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class ProductViewModel: ProductViewModelProtocol{
    
    
    var authServiceProtocol: AuthServiceProtocol!
    
    
    var brandID: Int = 0 {
        didSet {
            getProducts()
        }
    }
    
    private var favoriteProducts: Set<String> = []
    
    var products: [Products] = [] {
        didSet {
            calculatePriceRange()
            filterProducts()
        }
    }
    
    var filteredProducts: [Products] = [] {
        didSet {
            bindFilteredProducts()
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
    
    init(authServiceProtocol:AuthServiceProtocol){
        self.authServiceProtocol = authServiceProtocol
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json?collection_id=\(brandID)") { product in
            self.products = product?.products ?? []
        }
    }
    
    func addToFavourite(productId:String){
        
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
    
    func addProductToFavorites(productId: String, title: String, option1: String, option2: String, src: String) {
        guard let authServiceProtocol = authServiceProtocol else { return }
        
        authServiceProtocol.addProduct(productId: productId, title: title, option1: option1, option2: option2, src: src) { [weak self] success in
            if success {
                self?.favoriteProducts.insert(productId)
            }
        }

    }
    
    func deleteProduct(productId: String) {
        guard let authServiceProtocol = authServiceProtocol else { return }
        
        authServiceProtocol.deleteProduct(email: SharedDataRepository.instance.customerEmail ?? "Product No Email", productId: productId) { [weak self] success in
            if success {
                self?.favoriteProducts.remove(productId)
            }
        }
    }
    
    func isFavorite(productId: String) -> Bool {
        return favoriteProducts.contains(productId)
    }
 
}
