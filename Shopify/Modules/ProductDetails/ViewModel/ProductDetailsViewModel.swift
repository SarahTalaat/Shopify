//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    

    var networkServiceAuthenticationProtocol:NetworkServiceAuthenticationProtocol!
    var authServiceProtocol: AuthServiceProtocol!
    
    init(networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol,authServiceProtocol: AuthServiceProtocol){
        self.networkServiceAuthenticationProtocol = networkServiceAuthenticationProtocol
        self.authServiceProtocol = authServiceProtocol

    }
    
    var product: ProductResponseFromApi? {
        didSet{
            self.bindProductDetailsViewModelToController()
            
        }
    }
    
    
    var bindProductDetailsViewModelToController: (() -> ()) = {}

    
    func getColoursCount()->Int{
        return  Set(product?.product?.variants?.compactMap { $0.option2 } ?? []).count
    }
    
    func getSizeCount()->Int{
        return Set(product?.product?.variants?.compactMap { $0.option1 } ?? []).count
    }
    
    func getColour(index:Int) -> String{
        var colourArray = Array(product?.product?.variants?.compactMap { $0.option2 } ?? [])
        var colour = colourArray[index]
        return colour
    }
    
    func getsize(index:Int) -> String{
        var sizeArray = Array(product?.product?.variants?.compactMap { $0.option1 } ?? [])
        var size = sizeArray[index]
        return size
    }

    func getProductDetails() {
        guard let productIdString = retrieveStringFromUserDefaults(forKey: Constants.productId) else { return }
        guard let productIdInt = Int(productIdString) else { return }
        
        let urlString = APIConfig.endPoint("products/\(productIdInt)").url
        
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<ProductResponseFromApi, Error>) in
            switch result {
            case .success(let productResponse):
                print("PD product title response: \(String(describing: productResponse.product?.title))")
                self.product = productResponse
                
                
                self.addValueToUserDefaults(value: productResponse.product?.images?.first?.src, forKey: Constants.productImage)
                self.addValueToUserDefaults(value: productResponse.product?.title, forKey: Constants.productTitle)
                self.addValueToUserDefaults(value: productResponse.product?.title, forKey: Constants.productTitle)
                self.addValueToUserDefaults(value: productResponse.product?.variants?.first?.id, forKey: Constants.variantId)
                self.addValueToUserDefaults(value: productResponse.product?.id, forKey: Constants.productId)
                
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    
    func addToCart(){
        var draftOrder = draftOrder()
        var urlString = APIConfig.draft_orders.url
        postDraftOrderNetwork(urlString: urlString, parameters: draftOrder)
    }

    func postDraftOrderNetwork(urlString: String, parameters: [String:Any]) {
       networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .put, model: parameters, completion: { [weak self] (result: Result<DraftOrderResponsePUT, Error>) in
            switch result {
            case .success(let response):
                print("PD Draft order posted successfully: \(response)")
                ProductDetailsSharedData.instance.productVariantId = response.draftOrder?.id

            case .failure(let error):
                print("PD Failed to post draft order: \(error.localizedDescription)")
            }
        })
    }
    
    
    func draftOrder() -> [String:Any] {
        var variantLineItemId = UserDefaults.standard.string(forKey: Constants.variantId)
        var draftOrderId = UserDefaults.standard.string(forKey: Constants.shoppingCartId)
          

        let draftOrder: [String: Any] = [
            "draft_order": [
                "id":draftOrderId ,
                "line_items": [
                    [
                        "variant_id": variantLineItemId,
                        "quantity": 1
                    ]
                ]
            ]
        ]
        
            return draftOrder
    }
    
    
    func addProductToFirebase(){
        
        var encodedEmail = retrieveStringFromUserDefaults(forKey: Constants.customerEmail ?? "NOO Emaill")
        var productId = retrieveStringFromUserDefaults(forKey: Constants.productId)
        var productTitle = retrieveStringFromUserDefaults(forKey: Constants.productTitle)
        var productVendor = retrieveStringFromUserDefaults(forKey: Constants.productVendor)
        var productImage = retrieveStringFromUserDefaults(forKey: Constants.productImage)
        
        print("xy encoded email: \(encodedEmail)")
        print("xy productId: \(productId)")
        print("xy productTitle: \(productTitle)")
        print("xy productVendor: \(productVendor)")
        print("xy productImage: \(productImage)")
        
        authServiceProtocol.addProductToEncodedEmail(email: encodedEmail ?? "NOOO Email", productId: productId ?? "NOO ProductId", productTitle: productTitle ?? "No ProductTitle", productVendor: productVendor ?? "NOOO ProductVendor", productImage: productImage ?? "NOOO ProductImage")
        
        
    }
    
    func deleteProductFromFirebase(){
        var encodedEmail =  SharedMethods.encodeEmail(SharedDataRepository.instance.customerEmail ?? "No email")
        var productId = retrieveStringFromUserDefaults(forKey: Constants.productId) ?? "No productId"
        authServiceProtocol.deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: productId)
    }
    
    func addMultipleValuesToUserDefaults(productId: String, productTitle: String, productVendor:String, productImage: String){
        
        print("xy email singleton: \(SharedDataRepository.instance.customerEmail ?? "No email")")
        addValueToUserDefaults(value: SharedDataRepository.instance.customerEmail ?? "No email", forKey: Constants.customerEmail)
        addValueToUserDefaults(value: productId, forKey: Constants.productId)
        addValueToUserDefaults(value: productTitle, forKey: Constants.productTitle)
        addValueToUserDefaults(value: productVendor, forKey: Constants.productVendor)
        addValueToUserDefaults(value: productImage, forKey: Constants.productImage)
    }

    
//    func deleteValueFromUserDefaults(forKey key: String) {
//        UserDefaults.standard.removeObject(forKey: key)
//    }
 
    func addValueToUserDefaults(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func retrieveStringFromUserDefaults(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }



    
    
}
