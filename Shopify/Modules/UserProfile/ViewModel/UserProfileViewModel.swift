//
//  UserProfileViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 11/06/2024.
//

import Foundation

class UserProfileViewModel: UserProfileViewModelProfileProtocol {
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
    
    var bindAllOrders: (() -> ()) = {}
    var bindUserViewModelToController: (() -> ()) = {}
    
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
            
            NetworkUtilities.fetchData(responseType: OrdersResponse.self, endpoint: "orders.json") { item in
                if let allOrders = item?.orders {
                    self.orders = allOrders.filter { $0.email == email }
                } else {
                    self.orders = []
                }
                print(self.orders)
            }
        }
    
    
}
