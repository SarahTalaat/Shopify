//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class HomeViewModel{
    private let networkService = NetworkServiceAuthentication()

    var brands : [SmartCollection] = [] {
        didSet{
            self.bindBrandsData()
        }
    }
    
    var coupons : [PriceRules] = []{
        didSet{
         self.bindBrandsData()
        }
    }
    
    var bindBrandsData : (() -> ()) = {}
    var bindCouponsData: (() -> Void)?

    
    init(){
        getBrands()
        getCoupons()
    }
    
    func getBrands() {
        NetworkUtilities.fetchData(responseType: CollectionResponse.self, endpoint: "smart_collections.json") { brand in
            self.brands = brand?.smart_collections ??  []
          }
      }
    
    func getCoupons(){
        NetworkUtilities.fetchData(responseType: PriceRulesResponse.self, endpoint: "price_rules.json"){ coupon in
            self.coupons = coupon?.price_rules ?? []
        }
        print(coupons)
        bindCouponsData?()

    }
    
    
    
    
    func postDiscountCodes() {
        let discountCodes = ["SUMMERSALE20OFF", "SUMMERSALE10OFF"]
        
        for (index, coupon) in coupons.enumerated() {
            guard index < discountCodes.count else {
                print("Not enough discount codes provided for all price rules.")
                return
            }
            
            let discountCodeData = DiscountCode(price_rule_id: coupon.id, code: discountCodes[index])
            NetworkUtilities.postData(data: discountCodeData, endpoint: "price_rules/\(coupon.id)/discount_codes.json") { success in
                if success {
                    print("Discount code '\(discountCodes[index])' posted successfully for price rule with ID \(coupon.id)")
                } else {
                    print("Failed to post discount code '\(discountCodes[index])' for price rule with ID \(coupon.id)")
                }
            }
        }
    }
    
    func getDiscountCode(id: Int, completion: @escaping (String?) -> Void) {
        NetworkUtilities.fetchData(responseType: DiscountResponse.self, endpoint: "price_rules/\(id)/discount_codes.json") { response in
            let discountCode = response?.discount_codes.first?.code
            completion(discountCode)
        }
    }
}


//extension HomeViewModel {
//    
//    func setUserDraftOrderId(){
//        print("kkk UD home: draftOrderIDString: \(UserDefaults.standard.string(forKey: Constants.draftOrderId))")
//        var email = SharedDataRepository.instance.customerEmail ?? "No email"
//        print("kkk singleton home: draftOrderIDString: \(SharedDataRepository.instance.draftOrderId)")
//        var draftOrderId = SharedDataRepository.instance.draftOrderId
//       setDraftOrderId(email: email, shoppingCartID: "\(draftOrderId)")
//    }
//    
//    func setDraftOrderId(email:String, shoppingCartID:String){
//        FirebaseAuthService().setShoppingCartId(email: email, shoppingCartId: shoppingCartID) { error in
//            if let error = error {
//                print("Failed to set shopping cart ID: \(error.localizedDescription)")
//            } else {
//
//                print("Shopping cart ID set successfully!")
//            }
//        }
//    }
//    
//    func getDraftOrderID(email:String){
//        FirebaseAuthService().getShoppingCartId(email: email) { shoppingCartId, error in
//            if let error = error {
//                print("Failed to retrieve shopping cart ID: \(error.localizedDescription)")
//            } else if let shoppingCartId = shoppingCartId {
//                print("Shopping cart ID found: \(shoppingCartId)")
//            } else {
//                print("No shopping cart ID found for this user.")
//            }
//        }
//    }
//}
