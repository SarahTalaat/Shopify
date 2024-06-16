
//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    
 
    var networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol!
    
    
    init(networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol){
        self.networkServiceAuthenticationProtocol = networkServiceAuthenticationProtocol

    }
    
    var draftOrderDetails: OneDraftOrderResponse? {
        didSet{
           print("PD draftOrderDetails: \(draftOrderDetails)")
        }
    }
    
    var productDetails: GetProductResponse? {
        didSet{
            self.bindProductDetailsViewModelToController()
            print("PD productDetails: \(productDetails)")
        }
    }

    var productId = UserDefaults.standard.string(forKey: Constants.productId)
    
    var bindProductDetailsViewModelToController: (() -> ()) = {}


    func getProductDetails(){
        
        let productId = UserDefaults.standard.integer(forKey: Constants.productId)
        print("pd productid: \(productId)")
        let urlString = APIConfig.endPoint("products\(productId)").url
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .get, model: [:], completion: { [weak self] (result: Result<GetProductResponse, Error>) in
            switch result {
            case .success(let response):
                print("PD product details get successfully: \(response)")
                self?.productDetails = response
                UserDefaults.standard.set(response.product?.variants?.first?.id, forKey: Constants.variantIdInt)
                print("PD variantId UD: \(UserDefaults.standard.integer(forKey: Constants.variantIdInt))")
                print("PD variantId response: \(response.product?.variants?.first?.id ?? 0)")
            case .failure(let error):
                print("PD Failed to product details get: \(error.localizedDescription)")
            }
        })
    }


    func putDraftOrderNetwork(urlString: String, parameters: [String:Any]) {
       networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .put, model: parameters, completion: { [weak self] (result: Result<DraftOrderResponsePUT, Error>) in
            switch result {
            case .success(let response):
                print("PD Draft order posted successfully: \(response)")
                
            case .failure(let error):
                print("PD Failed to post draft order: \(error.localizedDescription)")
            }
        })
    }
    
    
    func draftOrder() -> [String:Any] {
        
        if let draftOrderIDString = UserDefaults.standard.string(forKey: Constants.shoppingCartId) {
                      
        let cleanedString = draftOrderIDString.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
      
            if let draftOrderIDInt = Int(cleanedString) {
                             
                print("xxx draftOrderInt: \(draftOrderIDInt)")
                UserDefaults.standard.set(draftOrderIDInt, forKey: Constants.draftOrderIdInt)
                let productVariantId = UserDefaults.standard.integer(forKey: Constants.variantIdInt)

                let draftOrder: [String: Any] = [
                        "draft_order": [
                            "id": draftOrderIDInt ,
                            "line_items": [
                                [
                                    "variant_id": productVariantId,
                                    "quantity": 1
                                ]
                            ]
                        ]
                    ]
                  return draftOrder
            } else {
                print("xxx Failed to convert \(cleanedString) to Int")
            }
        } else {

           print("xxx ShoppingCartId not found in UserDefaults")
        }
        
        return [:]
    }
        
            

    func addToCart() {
         
        
        let draftOrderParameter = draftOrder()
        
        let draftOrderIDInt: Int = UserDefaults.standard.integer(forKey: Constants.draftOrderIdInt)
        
        let urlString = APIConfig.endPoint("draft_orders/\(draftOrderIDInt)").url
            
        putDraftOrderNetwork(urlString: urlString, parameters: draftOrderParameter)
        deleteValueIfPresent(forKey: Constants.variantIdInt)
        deleteValueIfPresent(forKey: Constants.productId)
        }



        func deleteValueIfPresent(forKey key: String) {
            let defaults = UserDefaults.standard
            if defaults.object(forKey: key) != nil {
                defaults.removeObject(forKey: key)
                print("Deleted value for key '\(key)' in UserDefaults.")
            } else {
                print("No value found for key '\(key)' in UserDefaults.")
            }
        }
           
    func getColourArray(variants:[GetVariant])-> [String]{
         return variants.compactMap { $0.option2 }.filter { !$0.isEmpty }
    }
    func getsizeArray(variants:[GetVariant])-> [String]{
         return variants.compactMap { $0.option1 }.filter { !$0.isEmpty }
    }
    }
/*
 // Set an integer value
 UserDefaults.standard.set(123, forKey: "integerKey")
 
 
 // Get an integer value
 let intValue = UserDefaults.standard.integer(forKey: "integerKey")
 print("Integer Value: \(intValue)")
 
 
 // Remove a value
 UserDefaults.standard.removeObject(forKey: "key")
 */
