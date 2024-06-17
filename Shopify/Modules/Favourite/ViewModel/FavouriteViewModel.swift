//
//  FavouriteViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 16/06/2024.
//

import Foundation

class FavouriteViewModel: FavouriteViewModelProtocol {
    
   
    var authServiceProtocol: AuthServiceProtocol!
    
    init(authServiceProtocol: AuthServiceProtocol){
        self.authServiceProtocol = authServiceProtocol

    }
    
    
    var products: [ProductFromFirebase]?{
        didSet{
            self.bindProducts()
        }
    }
    
    var bindProducts:(()->()) = {}
    
    func retriveProducts(){
        authServiceProtocol.retrieveAllProductsFromEncodedEmail(email: SharedDataRepository.instance.customerEmail ?? "No email"){ [weak self] products in
            print("aaa products: \(products)")
            self?.products = products
            
        }
    }
    
}
