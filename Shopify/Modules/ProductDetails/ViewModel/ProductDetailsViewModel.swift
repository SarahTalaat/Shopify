//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation
import UIKit

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {

    

    var exchangeRates: [String: Double] = [:]
    
    var networkServiceAuthenticationProtocol:NetworkServiceAuthenticationProtocol!
    var authServiceProtocol: AuthServiceProtocol!
    
    init(networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol,authServiceProtocol: AuthServiceProtocol){
        self.networkServiceAuthenticationProtocol = networkServiceAuthenticationProtocol
        self.authServiceProtocol = authServiceProtocol
        loadFavoriteProducts()
        fetchUserFavorites()
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
    
    // Fetch user's favorite products from Firebase
    func fetchUserFavorites() {
        let email = SharedDataRepository.instance.customerEmail ?? "NoOo Email"
        let encodedEmail = SharedMethods.encodeEmail(email)
        
        authServiceProtocol.fetchFavorites(email: encodedEmail) { [weak self] favorites in
            self?.favoriteProducts = Set(favorites.keys.compactMap { Int($0) })
            self?.bindProductDetailsViewModelToController()
        }
    }

    
    func saveAddedToCartState(_ added: Bool) {
        var productID = Int(UserDefaults.standard.string(forKey: Constants.productId) ?? "")
        var customerID = Int(UserDefaults.standard.string(forKey: Constants.customerId) ?? "")
        
        UserDefaults.standard.set(added, forKey: "isAddedToCart"+"\(productID)"+"\(customerID)")
       
    }
    
    func saveButtonTitleState(addToCartUI:CustomButton){
        var productID = Int(UserDefaults.standard.string(forKey: Constants.productId) ?? "")
        var customerID = Int(UserDefaults.standard.string(forKey: Constants.customerId) ?? "")
        
        if let isAdded = UserDefaults.standard.object(forKey: "isAddedToCart"+"\(productID)"+"\(customerID)") as? Bool {
            addToCartUI.isAddedToCart = isAdded
        } else {
            addToCartUI.isAddedToCart = false // Default value if not previously set
        }
    }
    func toggleFavorite() {
        guard let productIdString = retrieveStringFromUserDefaults(forKey: Constants.productId),
              let productIdInt = Int(productIdString),
              let email = retrieveStringFromUserDefaults(forKey: Constants.customerEmail) else { return }

        let encodedEmail = SharedMethods.encodeEmail(email)
        
        if favoriteProducts.contains(productIdInt) {
            favoriteProducts.remove(productIdInt)
            authServiceProtocol.deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: "\(productIdInt)")
        } else {
            guard let productTitle = retrieveStringFromUserDefaults(forKey: Constants.productTitle),
                  let productId = retrieveStringFromUserDefaults(forKey: Constants.productId),
                  let productVendor = retrieveStringFromUserDefaults(forKey: Constants.productVendor),
                  let productImage = retrieveStringFromUserDefaults(forKey: Constants.productImage) else {
                fatalError("Failed to retrieve product details from UserDefaults")
            }

            favoriteProducts.insert(productIdInt)
            authServiceProtocol.addProductToEncodedEmail(email: encodedEmail, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage)
        }

        saveFavoriteProducts()
        bindProductDetailsViewModelToController()
    }
    
    func checkIfFavorited() -> Bool {
        var productId = retrieveStringFromUserDefaults(forKey: Constants.productId)
        guard let id = productId else {
            fatalError("Failed to retrieve product ID from UserDefaults")
        }
        return favoriteProducts.contains(Int(id) ?? 0)
    }
    
    func saveFavoriteProducts() {
      let email = SharedDataRepository.instance.customerEmail ?? "NOOOOOO Email"
        let encodedEmail = SharedMethods.encodeEmail(email)
        UserDefaults.standard.set(Array(favoriteProducts), forKey: "FavoriteProducts_\(encodedEmail)")
        UserDefaults.standard.synchronize()
    }
    
    
    func loadFavoriteProducts() {
        let email = SharedDataRepository.instance.customerEmail ?? "NooOo Email"
        let encodedEmail = SharedMethods.encodeEmail(email)
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteProducts_\(encodedEmail)") as? [Int] {
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


     func fetchExchangeRates() {
        let exchangeRateApiService = ExchangeRateApiService()
        exchangeRateApiService.getLatestRates { [weak self] result in
            switch result {
            case .success(let response):
                self?.exchangeRates = response.conversion_rates
                self?.getProductDetails()
            case .failure(let error):
                print("Error fetching exchange rates: \(error)")
            }
            self?.bindProductDetailsViewModelToController()
        }
    }
    

    func getProductDetails() {
        
        
        
        var draftOrderIdOptional = UserDefaults.standard.string(forKey: Constants.userDraftId)
        
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
                self.addValueToUserDefaults(value: productResponse.product?.vendor, forKey: Constants.productVendor)
                self.addValueToUserDefaults(value: productResponse.product?.variants?.first?.id, forKey: Constants.variantId)
                self.addValueToUserDefaults(value: productResponse.product?.id, forKey: Constants.productId)
                
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    
    func addToCart(){
        
        
        if let productId = UserDefaults.standard.string(forKey: Constants.productId){
            if let draftOrderId = UserDefaults.standard.string(forKey: Constants.userDraftId) {
                if let variantId = UserDefaults.standard.string(forKey: Constants.variantId){

                var urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
                    self.addNewLineItemToDraftOrder(urlString: urlString, variantId: Int(variantId) ?? 0, productId: Int(productId) ?? 0, quantity: 1)
                    
                }
            }
        }
    }
    
    func deleteFromCart(){

        if let productId = UserDefaults.standard.string(forKey: Constants.productId){
            if let draftOrderId = UserDefaults.standard.string(forKey: Constants.userDraftId) {
                if let variantId = UserDefaults.standard.string(forKey: Constants.variantId){

                var urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
                    
                    deleteLineItemFromDraftOrder(urlString: urlString, productId: Int(productId) ?? 0)
                }
            }
        }

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
    
    func getCartId(){
        print("PD cart id : \(UserDefaults.standard.string(forKey: Constants.userDraftId))")
    }

    func getDraftOrderID(email: String) {
        authServiceProtocol.getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                print("kkk *Failed* to retrieve shopping cart ID: \(error.localizedDescription)")
            } else if let shoppingCartId = shoppingCartId {
                print("kkk *PD* Shopping cart ID found: \(shoppingCartId)")
                SharedDataRepository.instance.draftOrderId = shoppingCartId
                print("kkk *PD* Singleton draft id: \(SharedDataRepository.instance.draftOrderId)")
            } else {
                print("kkk *PD* No shopping cart ID found for this user.")
            }
        }
    }
    
    func getUserDraftOrderId(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
        let email = SharedDataRepository.instance.customerEmail ?? "No email"
        self.getDraftOrderID(email: email)
        }
    }

    func addNewLineItemToDraftOrder(urlString: String, variantId: Int, productId: Int, quantity: Int) {
          // Fetch the existing draft order details
          networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<OneDraftOrderResponse, Error>) in
              switch result {
              case .success(let draftOrderResponse):
                  guard var draftOrder = draftOrderResponse.draftOrder else {
                      print("Draft order details are nil")
                      return
                  }
                  
                  // Check if a line item for the product ID already exists
                  if draftOrder.lineItems.contains(where: { $0.productId == productId }) {
                      print("Line item for product ID \(productId) already exists.")
                      return
                  }
                  
                  // Create a new line item dictionary with the provided data
                  let newLineItem: [String: Any] = [
                      "variant_id": variantId,
                      "product_id": productId,
                      "quantity": quantity,
                      // Add other properties as needed
                  ]
                  
                  // Convert existing line items to dictionary array
                  var existingLineItemsArray: [[String: Any]] = draftOrder.lineItems.map { lineItem in
                      return [
                          "variant_id": lineItem.variantId ?? 0,
                          "product_id": lineItem.productId ?? 0,
                          "quantity": lineItem.quantity,
                      ]
                  }
                  
                  // Append the new line item dictionary to lineItems array
                  existingLineItemsArray.append(newLineItem)
                  
                  // Convert draft order to dictionary representation
                  let draftOrderDictionary: [String: Any] = [
                      "draft_order": [
                          "id": draftOrder.id ?? 0, // Replace with actual draft order ID handling
                          "line_items": existingLineItemsArray
                      ]
                  ]
                  
                  // Make the PUT request to update the draft order
                  self.networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .put, model: draftOrderDictionary) { (result: Result<DraftOrderResponsePUT, Error>) in
                      switch result {
                      case .success(let updatedDraftOrder):
                          print("Updated draft order after adding new line item: \(updatedDraftOrder)")
                      case .failure(let error):
                          print("Failed to update draft order after adding new line item: \(error)")
                      }
                  }
                  
              case .failure(let error):
                  // Handle failure to fetch existing draft order
                  print("Failed to fetch existing draft order: \(error)")
              }
          }
      }
    
    
    
    func deleteLineItemFromDraftOrder(urlString: String, productId: Int) {
        // Fetch the existing draft order details
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case .success(let draftOrderResponse):
                guard var draftOrder = draftOrderResponse.draftOrder else {
                    print("Draft order details are nil")
                    return
                }
                
                // Convert existing line items to dictionary array and filter out the line item to be deleted
                let filteredLineItemsArray: [[String: Any]] = draftOrder.lineItems.compactMap { lineItem in
                    return lineItem.productId != productId ? [
                        "variant_id": lineItem.variantId ?? 0,
                        "product_id": lineItem.productId ?? 0,
                        "quantity": lineItem.quantity,
                        // Add other properties as needed
                    ] : nil
                }
                
                // Check if the line item was actually removed
                if filteredLineItemsArray.count == draftOrder.lineItems.count {
                    print("Line item for product ID \(productId) does not exist.")
                    return
                }
                
                // Convert draft order to dictionary representation
                let draftOrderDictionary: [String: Any] = [
                    "draft_order": [
                        "id": draftOrder.id ?? 0, // Replace with actual draft order ID handling
                        "line_items": filteredLineItemsArray
                    ]
                ]
                
                // Make the PUT request to update the draft order
                self.networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .put, model: draftOrderDictionary) { (result: Result<DraftOrderResponsePUT, Error>) in
                    switch result {
                    case .success(let updatedDraftOrder):
                        print("Updated draft order after deleting line item: \(updatedDraftOrder)")
                    case .failure(let error):
                        print("Failed to update draft order after deleting line item: \(error)")
                    }
                }
                
            case .failure(let error):
                // Handle failure to fetch existing draft order
                print("Failed to fetch existing draft order: \(error)")
            }
        }
    }
    
    func getCustomerIdFromFirebase(){
        var customerEmail = SharedDataRepository.instance.customerEmail ?? "No email"
        var encodedCustomerEmail = SharedMethods.encodeEmail(customerEmail)
        authServiceProtocol.fetchCustomerId(encodedEmail: encodedCustomerEmail) { customerId in
            if let customerId = customerId {
                print("Customer ID: \(customerId)")
                // Use customerId as needed in your app
                UserDefaults.standard.set(customerId, forKey: Constants.customerId)
            } else {
                print("Failed to fetch customerId")
                // Handle the case where customerId could not be fetched
            }
        }
    }

}
