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
    var bindCategory : (()->()) = {}
    var exchangeRates: [String: Double] = [:]
    init(){
        getCategory(id: .women )
        fetchExchangeRates()
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
    func fetchExchangeRates() {
            let exchangeRateApiService = ExchangeRateApiService()
            exchangeRateApiService.getLatestRates { [weak self] result in
                switch result {
                case .success(let response):
                    self?.exchangeRates = response.conversion_rates
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                }
                self?.bindCategory()
            }
        }
}
