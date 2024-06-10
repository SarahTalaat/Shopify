//
//  CategoryViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 10/06/2024.
//

import Foundation

class CategoryViewModel{
    var price = "0"
    var category : [Product] = [] {
        didSet{
            bindCategory()
        }
    }
    
    var bindCategory : (()->()) = {}
    
    init(){
        getCategory()
    }

    func getCategory() {
        let id = CategoryID.women.rawValue
        NetworkUtilities.fetchData(responseType: CategoryResponse.self, endpoint: "collections/303081455777/products.json") { product in
            if let products = product?.products {
                print("Fetched products: \(products.count)")
                self.category = products
            } else {
                print("No products fetched")
                self.category = []
            }
        }
    }
    
    func getPrice(id:Int) -> String{
        NetworkUtilities.fetchData(responseType: Products.self, endpoint: "products/\(id).json") { product in
            self.price = product?.variants.first?.price ?? "0"
        }
        return price
    }
    
    
    
    
    
    
    
    
    
}
