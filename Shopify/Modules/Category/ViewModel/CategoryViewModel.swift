//
//  CategoryViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 10/06/2024.
//

import Foundation

class CategoryViewModel{
    var price = "0"
    var subCategory : [Product] = []
    var category : [Product] = [] {
        didSet{
            bindCategory()
        }
    }
    var productsFromFirebase: [ProductFromFirebase] = []
    var categoryProduct: ProductModel? {
        didSet {
          
            print("Category categoryProductArray: \(String(describing: self.categoryProduct))")
            
        }
    }

    
    var productId: Int?
    
    var bindCategory : (()->()) = {}

    
    init(){

        getCategory(id: .women )
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
    
    

    
}


extension CategoryViewModel {
    
    func toggleFavorite(productId: String, completion: @escaping (Error?) -> Void) {
        let isFavorite = isProductFavorite(productId: productId)
        
        guard let email = retrieveStringFromUserDefaults(forKey: Constants.customerEmail) else {
            completion(nil) // Handle error or return if email is not available
            return
        }
        
        for product in category {
            if product.id == Int(productId){
                FirebaseAuthService().toggleFavorite(email: email, productId: productId, productTitle: product.title, productVendor: product.vendor, productImage: product.image.src , isFavorite: !isFavorite){ [weak self] error in
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
        var productId = category[index].id
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

