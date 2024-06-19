//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation


class ProductViewModel {

     var productsFromFirebase: [ProductFromFirebase] = []
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

            ProductDetailsSharedData.instance.filteredProducts = filteredProducts
            print(filteredProducts)

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

extension ProductViewModel {
    
    func toggleFavorite(productId: String, completion: @escaping (Error?) -> Void) {
        let isFavorite = isProductFavorite(productId: productId)
        
        guard let email = retrieveStringFromUserDefaults(forKey: Constants.customerEmail) else {
            completion(nil) // Handle error or return if email is not available
            return
        }
        
        for product in filteredProducts {
            if product.id == Int(productId){
                FirebaseAuthService().toggleFavorite(email: email, productId: productId, productTitle: product.title, productVendor: product.vendor, productImage: product.images.first?.src ?? "https://static.vecteezy.com/system/resources/previews/006/059/989/non_2x/crossed-camera-icon-avoid-taking-photos-image-is-not-available-illustration-free-vector.jpg", isFavorite: !isFavorite){ [weak self] error in
                    if error == nil {
                        // Update local state or perform any additional actions upon successful toggle
                        self?.updateFavoriteState(productId: productId, isFavorite: !isFavorite)
                    }
                    completion(error)
                }
            }
        }
        

    }
    
    func isProductFavorite(productId: String) -> Bool {
        return UserDefaults.standard.bool(forKey: productId)
    }
    
    func updateFavoriteState(productId: String, isFavorite: Bool) {
        UserDefaults.standard.set(isFavorite, forKey: productId)
        UserDefaults.standard.synchronize()
    }
    

    func addValueToUserDefaults(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getproductId(index: Int){
        var productId = filteredProducts[index].id
        addValueToUserDefaults(value: productId, forKey: Constants.productId)
        print("fff getProductId")
        print("fff productID \(productId)")
    }
    
    func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void) {
        FirebaseAuthService().retrieveAllProductsFromEncodedEmail(email: email) { products in
            self.productsFromFirebase = products
            completion(products)
        }
    }

    func retrieveStringFromUserDefaults(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    

}
