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

    
    var ordersCount: Int = 0 {
        didSet {
                self.bindOrdersCount()
        }
    }
    
    var bindOrdersCount: (() -> ()) = {}

    var bindUserViewModelToController: (() -> ()) = {}
    
    init(){
        getOrdersCount()
    }
    
    func userPersonalData(){
        
        if (SharedDataRepository.instance.isSignedIn == true){
        
        self.name = SharedDataRepository.instance.customerName
        self.email = SharedDataRepository.instance.customerEmail
        }
        else{
            self.name = "Guest"
            self.email = ""
        }
        print("Profile: name: \(SharedDataRepository.instance.customerName ?? "NONAME")")
        print("Profile: email: \(SharedDataRepository.instance.customerEmail ?? "NOEMAIL")")
        print("Profile: Cid: \(SharedDataRepository.instance.customerId ?? "NO CID")")
        print("Profile: favId: \(SharedDataRepository.instance.favouriteId ?? "NO FID")")
        print("Profile: shoppingCartId: \(SharedDataRepository.instance.draftOrderId ?? "NO ShopID")")
    }
    
    func getOrdersCount() {
        NetworkUtilities.fetchData(responseType: CountResponse.self, endpoint: "orders/count.json") { response in
            if let orders = response {
                self.ordersCount = orders.count
                print(self.ordersCount)
            } else {
                self.ordersCount = 0
            }
        }
    }
    
}
