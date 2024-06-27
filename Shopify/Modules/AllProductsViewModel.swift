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
    var network = NetworkServiceAuthentication()
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
        fetchUserFavorites()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json") { product in
            self.products = product?.products ?? []
            self.filteredProducts = self.products // Initialize filteredProducts
        }
    }// self?.bindAllProducts()
    
    func fetchExchangeRates() {
            
            network.requestFunction(urlString: APIConfig.usd.url3, method: .get, model: [:]){ (result: Result<ExchangeRatesResponse, Error>) in
                switch result {
                case .success(let response):
                    print("PD Exchange Rates Response\(response)")
                    self.exchangeRates = response.conversion_rates
                case .failure(let error):
                    print(error)
                }
                self.bindAllProducts()
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
    
    func isGuest()->Bool? {
      return  SharedDataRepository.instance.isSignedIn
       
    }
    
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
            self?.getProducts()
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
