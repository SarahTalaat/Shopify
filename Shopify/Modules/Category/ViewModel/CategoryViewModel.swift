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
    
//    var categoryProduct: ProductModel? {
//        didSet {
//
//            ProductDetailsSharedData.instance.filteredCategory = categoryProduct
//            print("Category categoryproductArray: \(categoryProduct)")
//
//
//        }
//    }
    
    var categoryProduct: ProductModel? {
        didSet {
          
            ProductDetailsSharedData.instance.filteredCategory = self.categoryProduct
            print("Category categoryProductArray: \(String(describing: self.categoryProduct))")
            
        }
    }

    
    
    var productId: Int?
    
    var bindCategory : (()->()) = {}
    
    var networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol!
    
    init(networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol){
        self.networkServiceAuthenticationProtocol = networkServiceAuthenticationProtocol
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
    
    func productIndexPath(index: Int) {
         print("CategoryViewModel: category vm index: \(index)")
         ProductDetailsSharedData.instance.brandsProductIndex = index
         let product = category[index]
         getSingleProductResponse(productId: product.id) { [weak self] product in
             if let product = product {
                 print("CategoryViewModel: Product received: \(product)")
                 self?.handleReceivedProduct(product)
             } else {
                 print("CategoryViewModel: Failed to fetch product details.")
             }
         }
     }

     private func handleReceivedProduct(_ product: ProductModel) {
         print("CategoryViewModel: Handling received product: \(product)")
         DispatchQueue.main.async {
             ProductDetailsSharedData.instance.filteredCategory = product
         }
     }
    

  
    func getSingleProductResponse(productId: Int, completion: @escaping (ProductModel?) -> Void) {
        let urlString = APIConfig.endPoint("products/\(productId)").url
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .get, model: [:], completion: { [weak self] (result: Result<OneProductResponse, Error>) in
            switch result {
            case .success(let response):
                print("CategoryViewModel: Category product response successfully: \(response)")
                self?.categoryProduct = response.product
                ProductDetailsSharedData.instance.filteredCategory = response.product
                UserDefaults.standard.set(response.product.variants.first?.id, forKey: Constants.variantId)
                completion(response.product)
            case .failure(let error):
                print("CategoryViewModel: Category Failed to post draft order: \(error.localizedDescription)")
                completion(nil)
            }
        })
    }

    
}
