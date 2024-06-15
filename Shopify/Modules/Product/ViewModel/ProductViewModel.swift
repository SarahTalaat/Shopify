//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class ProductViewModel {
    
    var brandID: Int = 0 {
        didSet {
            getProducts()
        }
    }
    var exchangeRates: [String: Double] = [:]
    var products: [Products] = [] {
        didSet {
            calculatePriceRange()
            applyFilters()
        }
    }
    
    var filteredProducts: [Products] = [] {
        didSet {
            bindFilteredProducts()
        }
    }
    
    var currentFilters: (price: Float?, color: String?, size: (type: String, value: String)?) = (nil, nil, nil) {
        didSet {
            applyFilters()
        }
    }
    
    var minPrice: Float = 0
    var maxPrice: Float = 1000
    
    var bindFilteredProducts: (() -> ()) = {}
    var bindPriceRange: (() -> ()) = {}
    
    var currentMaxPrice: Float = 1000 {
        didSet {
            currentFilters.price = currentMaxPrice
        }
    }
    
    init() {
        getProducts()
        fetchExchangeRates()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json?collection_id=\(brandID)") { product in
            self.products = product?.products ?? []
        }
    }
    
    func calculatePriceRange() {
        let prices = products.compactMap { Float($0.variants.first?.price ?? "0") }
        minPrice = 0
        maxPrice = prices.max() ?? 1000
        currentMaxPrice = maxPrice
        bindPriceRange()
    }
    
    func applyFilters() {
        filteredProducts = products
        
        if let maxPrice = currentFilters.price {
            filteredProducts = filteredProducts.filter { product in
                if let productPrice = Float(product.variants.first?.price ?? "0") {
                    return productPrice <= maxPrice
                }
                return false
            }
        }
        
        if let color = currentFilters.color, color != "All" {
            filteredProducts = filteredProducts.filter { product in
                for option in product.options where option.name == "Color" {
                    if option.values.contains(color) {
                        return true
                    }
                }
                return false
            }
        }
        
        if let size = currentFilters.size, size.value != "All" {
            filteredProducts = filteredProducts.filter { product in
                if product.product_type == size.type {
                    for option in product.options where option.name == "Size" {
                        if option.values.contains(size.value) {
                            return true
                        }
                    }
                }
                return false
            }
        }
    }
    
    private func fetchExchangeRates() {
        let exchangeRateApiService = ExchangeRateApiService()
        exchangeRateApiService.getLatestRates { [weak self] result in
            switch result {
            case .success(let response):
                self?.exchangeRates = response.conversion_rates
            case .failure(let error):
                print("Error fetching exchange rates: \(error)")
            }
            self?.bindFilteredProducts()
        }
    }
}
