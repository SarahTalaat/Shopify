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
    
    init(){

        getCategory(id: .women )
        fetchExchangeRates()
        fetchUserFavorites()
    }
 
    func getCategory(id:CategoryID) {
        NetworkUtilities.fetchData(responseType: CategoryResponse.self, endpoint: "collections/\(id.rawValue)/products.json") { product in
            if let products = product?.products {
                print("Fetched products: \(products.count)")
                
                self.subCategory = products
                self.category = products
            } else {
                print("No products fetched")
                self.category = []
            }
        }
    }
    func getPrice(id: Int, completion: @escaping (String) -> Void) {
        NetworkUtilities.fetchData(responseType: SingleProduct.self, endpoint: "products/\(id).json") { product in
            let price = product?.product.variants.first?.price ?? "0"
            completion(price)
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
            
            network.requestFunction(urlString: APIConfig.usd.url2, method: .get, model: [:]){ (result: Result<ExchangeRatesResponse, Error>) in
                switch result {
                case .success(let response):
                    print("PD Exchange Rates Response\(response)")
                    self.exchangeRates = response.conversion_rates
                case .failure(let error):
                    print(error)
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

