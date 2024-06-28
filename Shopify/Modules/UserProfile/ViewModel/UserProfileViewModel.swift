//
//  UserProfileViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 11/06/2024.
//

import Foundation

class UserProfileViewModel {
    var name: String? {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    var email: String? {
        didSet {
            self.bindUserViewModelToController()
        }
    }

    var orders: [Orders] = [] {
        didSet {
            bindAllOrders()
        }
    }
    
    var customerEmail = SharedDataRepository.instance.customerEmail
    var bindAllOrders: (() -> ()) = {}
    var bindUserViewModelToController: (() -> ()) = {}
    private let networkService = NetworkServiceAuthentication.instance

    
    init(){
        getOrders()

    }

    
    func userPersonalData(){
        
        if (SharedDataRepository.instance.isSignedIn == true){
        
        self.name = SharedDataRepository.instance.customerName
        self.email = SharedDataRepository.instance.customerEmail
        }
        else{
            self.name = ""
            self.email = ""
        }
        print("Profile: name: \(SharedDataRepository.instance.customerName ?? "NONAME")")
        print("Profile: email: \(SharedDataRepository.instance.customerEmail ?? "NOEMAIL")")
        print("Profile: Cid: \(SharedDataRepository.instance.customerId ?? "NO CID")")
        print("Profile: favId: \(SharedDataRepository.instance.favouriteId ?? "NO FID")")
        print("Profile: shoppingCartId: \(SharedDataRepository.instance.draftOrderId ?? "NO ShopID")")
    }
    

    

    func getOrders() {
           guard let email = SharedDataRepository.instance.customerEmail else {
               print("Customer email is nil")
               return
           }
           
           let urlString = APIConfig.endPoint("orders").url
           networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<OrdersResponse, Error>) in
               switch result {
               case .success(let response):
                   self.orders = response.orders.filter { $0.email == email }
               case .failure(let error):
                   print("Failed to fetch orders: \(error.localizedDescription)")
                   self.orders = []
               }
               print(self.orders)
           }
       }
}
