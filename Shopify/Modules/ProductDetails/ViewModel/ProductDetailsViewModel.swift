
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
    
    var productDetails: OneDraftOrderResponse? {
        didSet{
            self.bindProductDetailsViewModelToController()
        }
    }


    var productId = UserDefaults.standard.string(forKey: Constants.productId)
    
    var bindProductDetailsViewModelToController: (() -> ()) = {}


    func postProduct(variantId: Int){
        let urlString = APIConfig.draft_orders.url
        let draftOrder = draftOrder(variantId: variantId)
        
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .post, model: draftOrder, completion: { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case .success(let response):
                self?.productDetails = response
                UserDefaults.standard.set(response.draftOrder, forKey: <#T##String#>)
            case .failure(let error):
                print("PD Failed to post draft order: \(error.localizedDescription)")
            }
        })
    }
    
//    func getProductDetails(){
//        var productId = UserDefaults.standard.integer(forKey: Constants.productId)
//        var urlString = APIConfig.endPoint("products\()")
//    }


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
    
    
    func draftOrder(variantId:Int) -> [String:Any] {
        
        if let draftOrderIDString = UserDefaults.standard.string(forKey: Constants.shoppingCartId) {
                      
        let cleanedString = draftOrderIDString.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
      
            if let draftOrderIDInt = Int(cleanedString) {
                             
                print("xxx draftOrderInt: \(draftOrderIDInt)")
                UserDefaults.standard.set(draftOrderIDInt, forKey: Constants.draftOrderIdInt)

                let draftOrder: [String: Any] = [
                        "draft_order": [
                            "id": draftOrderIDInt ,
                            "line_items": [
                                [
                                    "variant_id": variantId,
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
    }
        
            

    func addToCart() {
         
        var variantId =
        var draftOrderParameter = draftOrder(variantId:variantId)
        
        var draftOrderIDInt = UserDefaults.standard.object(forKey: Constants.draftOrderIdInt)
        
        let urlString = APIConfig.endPoint("draft_orders/\(draftOrderIDInt)").url
            
            postDraftOrderNetwork(urlString: <#T##String#>, parameters: <#T##[String : Any]#>)
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
