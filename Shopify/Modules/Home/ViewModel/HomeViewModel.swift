//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation

class HomeViewModel{
  
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

}
