//
//  AllProductsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 11/06/2024.
//

import Foundation

class AllProductsViewModel {
    var productsFromFirebase: [ProductFromFirebase] = []
    var products: [Products] = [] {
        didSet {
            ProductDetailsSharedData.instance.filteredSearch = products
            filteredProducts = products
            bindAllProducts()
        }
    }
    var filteredProducts: [Products] = []
    
    var exchangeRates: [String: Double] = [:]
    var bindAllProducts: (() -> ()) = {}
    
    init() {
        getProducts()
        fetchExchangeRates()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json") { product in
            self.products = product?.products ?? []
            self.filteredProducts = self.products // Initialize filteredProducts
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
            self?.bindAllProducts()
        }
    }
    
    func filterProducts(by query: String) {
        if query.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.trimmedTitle.lowercased().contains(query.lowercased()) }
        }
        bindAllProducts()
    }
}
extension AllProductsViewModel {
    
    func toggleFavorite(productId: String, completion: @escaping (Error?) -> Void) {
        let isFavorite = isProductFavorite(productId: productId)
        
        guard let email = retrieveStringFromUserDefaults(forKey: Constants.customerEmail) else {
            completion(nil) // Handle error or return if email is not available
            return
        }
        
        for product in products {
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

    func productIndexPath(index: Int){
        print("category vm index: \(index)")
        ProductDetailsSharedData.instance.brandsProductIndex = index

    }
    
    func getproductId(index: Int){
        var productId = products[index].id
        addValueToUserDefaults(value: productId, forKey: Constants.productId)
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

extension Products {
    var trimmedTitle: String {
        if let range = title.range(of: "|") {
            var truncatedString = String(title[range.upperBound...]).trimmingCharacters(in: .whitespaces)
            if let nextRange = truncatedString.range(of: "|") {
                truncatedString = String(truncatedString[..<nextRange.lowerBound]).trimmingCharacters(in: .whitespaces)
            }
            return truncatedString
        }
        return title
    }
}
