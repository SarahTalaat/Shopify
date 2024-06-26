//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class ProductViewModel {
    var error: Error?
    var minPrice: Float = 0
    var maxPrice: Float = 1000
    
    var productsFromFirebase: [ProductFromFirebase] = []
    var userFavorites: [String: Bool] = [:]
    
    
    
    var exchangeRates: [String: Double] = [:]
    
    var brandID: Int = 0 {
        didSet {
            getProducts()
        }
    }
    
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
        }
    }
    
    var currentFilters: (price: Float?, color: String?, size: (type: String, value: String)?) = (nil, nil, nil) {
        didSet {
            applyFilters()
        }
    }
    
    var currentMaxPrice: Float = 1000 {
        didSet {
            currentFilters.price = currentMaxPrice
        }
    }
    
    var searchQuery: String? {
        didSet {
            applyFilters()
        }
    }
    
    var bindFilteredProducts: (() -> ()) = {}
    var bindPriceRange: (() -> ()) = {}
    private let networkService = NetworkServiceAuthentication()

    init() {
        getProducts()
        fetchExchangeRates()
        fetchUserFavorites()
    }
 
    func getProducts() {
        let urlString = "https://\(APIConfig.hostName)/admin/api/\(APIConfig.version)/products.json?collection_id=\(brandID)"
         networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<ProductResponse, Error>) in
             switch result {
             case .success(let response):
                 self.products = response.products
             case .failure(let error):
                 self.error = error
                 self.products = []
                 print("Failed to fetch products: \(error.localizedDescription)")
             }
         }
     }
    
    func calculatePriceRange() {
        let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
        let exchangeRate = self.exchangeRates[selectedCurrency] ?? 1.0
        
        let prices = products.compactMap { product -> Float? in
            if let productPrice = Double(product.variants.first?.price ?? "0") {
                let convertedPrice = productPrice * exchangeRate
                return Float(convertedPrice)
            }
            return nil
        }
        
        minPrice = 0
        maxPrice = prices.max() ?? 1000
        currentMaxPrice = maxPrice
        bindPriceRange()
    }
    
    func applyFilters() {
        filteredProducts = products
        
        if let maxPrice = currentFilters.price {
            filteredProducts = filteredProducts.filter { product in
                if let productPrice = Double(product.variants.first?.price ?? "0") {
                    let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                    let exchangeRate = self.exchangeRates[selectedCurrency] ?? 1.0
                    let convertedPrice = productPrice * exchangeRate
                    return Float(convertedPrice) <= maxPrice
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
        
        if let query = searchQuery?.lowercased(), !query.isEmpty {
            filteredProducts = filteredProducts.filter { product in
                return product.trimmedTitle.lowercased().contains(query)
            }
        }
    }
    
    private func fetchExchangeRates() {
        let exchangeRateApiService = ExchangeRateApiService()
        exchangeRateApiService.getLatestRates { [weak self] result in
            switch result {
            case .success(let response):
                self?.exchangeRates = response.conversion_rates
                self?.applyFilters()
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
        
        var email = SharedDataRepository.instance.customerEmail ?? "No emaillllllll"
        
        if let product = filteredProducts.first(where: { "\($0.id)" == productId }) {
            FirebaseAuthService().toggleFavorite(email: email, productId: productId, productTitle: product.title, productVendor: product.vendor, productImage: product.images.first?.src ?? "", isFavorite: !isFavorite) { [weak self] error in
                if error == nil {
                    self?.userFavorites[productId] = !isFavorite
                    self?.updateFavoriteState(productId: productId, isFavorite: !isFavorite)
                }
                completion(error)
            }
        } else {
            completion(nil)
        }
    }

    func fetchUserFavorites() {
        guard let email = retrieveStringFromUserDefaults(forKey: Constants.customerEmail) else { return }
        
        FirebaseAuthService().fetchFavorites(email: email) { [weak self] favorites in
            self?.userFavorites = favorites
            self?.applyFilters()
        }
    }
    
    func isProductFavorite(productId: String) -> Bool {
           return userFavorites[productId] ?? false
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
