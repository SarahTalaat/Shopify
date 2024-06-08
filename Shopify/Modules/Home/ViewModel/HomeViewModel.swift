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
    
    var bindBrandsData : (() -> ()) = {}
    
    init(){
        getBrands()
    }
    
    func getBrands() {
        NetworkUtilities.fetchData(responseType: CollectionResponse.self, endpoint: "smart_collections.json") { brand in
            self.brands = brand?.smart_collections ??  []
          }
      }

}
