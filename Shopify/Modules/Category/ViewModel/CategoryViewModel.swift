//
//  CategoryViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 10/06/2024.
//

import Foundation
class CategoryViewModel{
    var price = "0"
    var productId: Int?
    var subCategory : [Product] = []
    
    var userFavorites: [String: Bool] = [:]
    var productsFromFirebase: [ProductFromFirebase] = []
    var network = NetworkServiceAuthentication()
    var category: [Product] = [] {
         didSet {
             applyFilters()
         }
     }
     var filteredProducts: [Product] = [] {
         didSet {
             bindCategory()
         }
     }
     
    var categoryProduct: ProductModel? {
        didSet {
          
            print("Category categoryProductArray: \(String(describing: self.categoryProduct))")
            
        }
    }
    var searchQuery: String? {
        didSet {
            applyFilters()
        }
    }
    
    
    var bindCategory : (()->()) = {}
    var exchangeRates: [String: Double] = [:]
    private let networkService = NetworkServiceAuthentication()

    init(){

        getCategory(id: .women )
        fetchExchangeRates()
        fetchUserFavorites()
    }
 
    func getCategory(id: CategoryID) {
           let urlString = APIConfig.endPoint("collections/\(id.rawValue)/products").url
           networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<CategoryResponse, Error>) in
               switch result {
               case .success(let response):
                   self.subCategory = response.products
                   self.category = response.products
               case .failure(let error):
                   print("Failed to fetch category products: \(error.localizedDescription)")
                   self.category = []
               }
           }
       }
       
       func getPrice(id: Int, completion: @escaping (String) -> Void) {
           let urlString = APIConfig.endPoint("products/\(id)").url
           networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<SingleProduct, Error>) in
               switch result {
               case .success(let response):
                   let price = response.product.variants.first?.price ?? "0"
                   completion(price)
               case .failure(let error):
                   print("Failed to fetch product price: \(error.localizedDescription)")
                   completion("0")
               }
           }
       }
       
    func filterBySubCategory(subcategory:SubCategories){
        if subcategory == .all{
            self.category = self.subCategory
        } else {
            self.category = self.subCategory.filter{$0 .product_type == subcategory.rawValue}
        }

    
    }
  
    func applyFilters() {
        var filtered = category
        
        if let query = searchQuery?.lowercased(), !query.isEmpty {
            filtered = filtered.filter { $0.title.lowercased().contains(query) }
        }
        
        filteredProducts = filtered
    }
    
     func fetchExchangeRates() {
                let exchangeRateApiService = ExchangeRateApiService()
                exchangeRateApiService.getLatestRates { [weak self] result in
                    switch result {
                    case .success(let response):
                        self?.exchangeRates = response.conversion_rates
                    case .failure(let error):
                        print("Error fetching exchange rates: \(error)")
                    }
                  
                }
            }

    
 
}

extension CategoryViewModel {
    
    
    func toggleFavorite(productId: String, completion: @escaping (Error?) -> Void) {
        let isFavorite = isProductFavorite(productId: productId)
        
        var email = SharedDataRepository.instance.customerEmail ?? "No emaillllllll"
        
        if let product = filteredProducts.first(where: { "\($0.id)" == productId }) {
            FirebaseAuthService().toggleFavorite(email: email, productId: productId, productTitle: product.title, productVendor: product.vendor, productImage: product.image.src ?? "", isFavorite: !isFavorite) { [weak self] error in
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
    
    func isGuest()->Bool? {
      return  SharedDataRepository.instance.isSignedIn
       
    }

}

