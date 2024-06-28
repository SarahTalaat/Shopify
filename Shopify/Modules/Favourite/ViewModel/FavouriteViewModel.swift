//
//  FavouriteViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 16/06/2024.
//

import Foundation
import Reachability

class FavouriteViewModel {
    
   
    init(){
        
    }
    

    var products: [ProductFromFirebase]?{
        didSet{
            self.bindProducts()
        }
    }
    
    var bindProducts:(()->()) = {}
    
    func retriveProducts(){
        FirebaseAuthService.instance
    .retrieveAllProductsFromEncodedEmail(email: SharedDataRepository.instance.customerEmail ?? "No email"){ [weak self] products in
            print("aaa products: \(products)")
            self?.products = products
            
        }
    }
    
    var reachability: Reachability?
    var networkStatusChanged: ((Bool) -> Void)?
    func setupReachability() {
        reachability = try? Reachability()
        reachability?.whenReachable = { reachability in
            self.networkStatusChanged?(reachability.connection == .wifi)
            print("wifi connection")
        }
        reachability?.whenUnreachable = { _ in
            self.networkStatusChanged?(false)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func deleteFromArray(index: Int){
        let id = products?[index].productId
        addValueToUserDefaults(value: id ?? 0, forKey: Constants.productId)
        print("mmm id: \(id ?? "no id")")
    }
    func addValueToUserDefaults(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func deleteProductFromFirebase(index: Int){
        deleteFromArray(index: index)
        let encodedEmail =  SharedMethods.encodeEmail(SharedDataRepository.instance.customerEmail ?? "No email")
        let productId = retrieveStringFromUserDefaults(forKey: Constants.productId) ?? "No productId"
        
        print("mmm productId: \(productId)")
        FirebaseAuthService.instance
    .deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: productId)
    }
    
    func retrieveStringFromUserDefaults(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func getproductId(index: Int){
        let productId = products?[index].productId
        addValueToUserDefaults(value: productId, forKey: Constants.productId)
    }
    func isProductsEmpty() -> Bool {
        if products?.count == 0 {
            return true
        }else{
            return false
        }
    }
    
}
