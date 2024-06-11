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

    var bindUserViewModelToController: (() -> ()) = {}
    
    func userPersonalData(){
        self.name = SharedDataRepository.instance.customerName
        self.email = SharedDataRepository.instance.customerEmail
        
        print("Profile: name: \(SharedDataRepository.instance.customerName ?? "NONAME")")
        print("Profile: email: \(SharedDataRepository.instance.customerEmail ?? "NOEMAIL")")
        print("Profile: Cid: \(SharedDataRepository.instance.customerId ?? "NO CID")")
        print("Profile: favId: \(SharedDataRepository.instance.favouriteId ?? "NO FID")")
        print("Profile: shoppingCartId: \(SharedDataRepository.instance.shoppingCartId ?? "NO ShopID")")
    }
    
}
