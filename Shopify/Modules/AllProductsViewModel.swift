//
//  AllProductsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 11/06/2024.
//

import Foundation

class AllProductsViewModel {
    var userFavorites: [String: Bool] = [:]
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
    private let networkService = NetworkServiceAuthentication()

    
    init() {
        getProducts()
        fetchExchangeRates()
        fetchUserFavorites()
    }
    
    func getProducts() {
          let urlString = APIConfig.endPoint("products").url
          networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<ProductResponse, Error>) in
              switch result {
              case .success(let response):
                  self.products = response.products
                  self.filteredProducts = self.products
              case .failure(let error):
                  self.products = []
                  print("Failed to fetch products: \(error.localizedDescription)")
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
