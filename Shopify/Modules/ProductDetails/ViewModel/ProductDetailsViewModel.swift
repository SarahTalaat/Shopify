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
    
    var favoriteProducts: Set<Int> = []
    
    var product: ProductResponseFromApi? {
        didSet{
            self.bindProductDetailsViewModelToController()
            
        }
    }
    
    var isFavorited: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isFavoritedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.isFavoritedKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func toggleFavorite() {
        guard let productIdString = retrieveStringFromUserDefaults(forKey: Constants.productId) else { return }
        guard let productIdInt = Int(productIdString) else { return }
        var email = retrieveStringFromUserDefaults(forKey:Constants.customerEmail) ?? "Nooo email"
        var encodedEmail = SharedMethods.encodeEmail(email)
        
        print("vvv encoded email \(encodedEmail)")
        var productTitle = retrieveStringFromUserDefaults(forKey: Constants.productTitle)
        var productId = retrieveStringFromUserDefaults(forKey: Constants.productId)
        var productVendor = retrieveStringFromUserDefaults(forKey: Constants.productVendor)
        var productImage = retrieveStringFromUserDefaults(forKey: Constants.productImage)
        
        guard let title = productTitle else {
            fatalError("Failed to retrieve product title from UserDefaults")
        }
        guard let id = productId else {
            fatalError("Failed to retrieve product ID from UserDefaults")
        }
        guard let vendor = productVendor else {
            fatalError("Failed to retrieve product vendor from UserDefaults")
        }
        guard let image = productImage else {
            fatalError("Failed to retrieve product image from UserDefaults")
        }
        
        if favoriteProducts.contains(productIdInt) {
            favoriteProducts.remove(productIdInt)

            authServiceProtocol.deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: "\(productIdInt)")
        } else {
            favoriteProducts.insert(productIdInt)
            authServiceProtocol.addProductToEncodedEmail(email: encodedEmail, productId: id, productTitle: title, productVendor: vendor, productImage: image)
        }
        saveFavoriteProducts()
    }
    
    func checkIfFavorited() -> Bool {
        var productId = retrieveStringFromUserDefaults(forKey: Constants.productId)
        guard let id = productId else {
            fatalError("Failed to retrieve product ID from UserDefaults")
        }
        return favoriteProducts.contains(Int(id) ?? 0)
    }
    
    func saveFavoriteProducts() {
        UserDefaults.standard.set(Array(favoriteProducts), forKey: "FavoriteProducts")
        UserDefaults.standard.synchronize()
    }
    
    func loadFavoriteProducts() {
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteProducts") as? [Int] {
            favoriteProducts = Set(savedFavorites)
        }
    }
    
    var bindProductDetailsViewModelToController: (() -> ()) = {}
    

    func getSizeCount() -> Int {
        guard let variants = product?.product?.variants else { return 0 }
        
        // Filter out nils and duplicates using a Set
        let uniqueSizes = Set(variants.compactMap { $0.option1 })
        
        return uniqueSizes.count
    }


    
    func getColoursCount() -> Int {
        guard let variants = product?.product?.variants else { return 0 }
        
        // Filter out nils and duplicates using a Set
        let uniqueColors = Set(variants.compactMap { $0.option2 })
        
        return uniqueColors.count
    }

    
    func getColour(index: Int) -> String? {
        guard let variants = product?.product?.variants else { return nil }
        
        // Ensure index is within bounds
        guard index < variants.count else { return nil }
        
        return variants[index].option2
    }
    func getSize(index: Int) -> String? {
        guard let variants = product?.product?.variants else { return nil }
        
        // Ensure index is within bounds
        guard index < variants.count else { return nil }
        
        return variants[index].option1
    }



    func getProductDetails() {
        
        
        
        var draftOrderIdOptional = UserDefaults.standard.string(forKey: Constants.draftOrderId)
        
        print("eee draftOrderIdOptional: \(draftOrderIdOptional)")
        
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
        if let draftOrderId = UserDefaults.standard.string(forKey: Constants.shoppingCartId) {
            var urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
            updateDraftOrderNetwork(draftOrderId: urlString, newLineItem: draftOrder)
        }

    }
    func deleteFromCart(){
        //deletes draft order not line item , needs to be corrected!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     //  let draftOrderId = 1034577543329
     //   var urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
     //   deleteDraftOrderNetwork(urlString: urlString, parameters: [:])
  

    }
    
    func updateDraftOrderNetwork(draftOrderId: String, newLineItem: [String: Any]) {
        let fetchUrlString = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/\(draftOrderId).json"
        
        print("Fetching draft order with URL: \(fetchUrlString)")
        
        networkServiceAuthenticationProtocol.requestFunction(urlString: fetchUrlString, method: .get, model: [:], completion: { [weak self] (result: Result<DraftOrderResponsePUT, Error>) in
            switch result {
            case .success(let response):
                print("Successfully fetched draft order: \(response)")
                var existingLineItems = response.draftOrder?.lineItems ?? []
                
                // Manually construct a LineItemPUT from the dictionary
                if let newLineItem = self?.createLineItemPUT(from: newLineItem) {
                    existingLineItems.append(newLineItem)
                } else {
                    print("Failed to create LineItemPUT from newLineItem dictionary.")
                    return
                }
                
                let updateUrlString = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/\(draftOrderId).json"
                let parameters: [String: Any] = [
                    "draft_order": [
                        "line_items": existingLineItems.map { $0.toDictionary() }
                    ]
                ]
                
                print("Updating draft order with URL: \(updateUrlString)")
                print("Parameters: \(parameters)")
                
                self?.networkServiceAuthenticationProtocol.requestFunction(urlString: updateUrlString, method: .put, model: parameters, completion: { (updateResult: Result<DraftOrderResponsePUT, Error>) in
                    switch updateResult {
                    case .success(let updateResponse):
                        print("PD Draft order updated successfully: \(updateResponse)")
                        ProductDetailsSharedData.instance.productVariantId = updateResponse.draftOrder?.id
                        
                    case .failure(let error):
                        print("PD Failed to update draft order: \(error.localizedDescription)")
                    }
                })
                
            case .failure(let error):
                print("PD Failed to fetch draft order: \(error.localizedDescription)")
            }
        })
    }

    private func createLineItemPUT(from dictionary: [String: Any]) -> LineItemPUT? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(LineItemPUT.self, from: jsonData)
    }
    
    func deleteDraftOrderNetwork(urlString: String, parameters: [String:Any]) {
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .delete, model: parameters, completion: { [weak self] (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success(let response):
                print("PD Draft order deleted successfully: \(response)")

            case .failure(let error):
                print("PD Failed to delete draft order: \(error.localizedDescription)")
            }
        })
    }
    
    
    func draftOrder() -> [String:Any] {
        var variantLineItemId = UserDefaults.standard.string(forKey: Constants.variantId)
        print("kkk 1. variantID: \(variantLineItemId)")
        
        
        if let variantLineItemId = UserDefaults.standard.string(forKey: Constants.variantId) {
            
            print("kkk 2. variantID: \(variantLineItemId)")
            if let draftOrderId = UserDefaults.standard.string(forKey: Constants.shoppingCartId) {
                print("kkk draftOrderId: \(draftOrderId)")
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
            } else {
                print("kkk Constants.shoppingCartId does not exist in UserDefaults")
                return [:]
            }

        }
        return [:]
        
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
