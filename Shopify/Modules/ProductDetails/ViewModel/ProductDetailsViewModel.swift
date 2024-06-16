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
    
    var filteredProducts: [Products]? {
        didSet{
            self.checkAndBindData()
        }
    }
    
    var filteredCategory: ProductModel? {
        didSet{
            self.checkAndBindData()
        }
    }
    
    var filteredSearch: [Products]? {
        didSet{
            self.checkAndBindData()
        }
    }
    
    var productFromArray: Products?
    var productModel: ProductModel?
    
    var customProductDetails: CustomProductDetails? {
        didSet{
            self.checkAndBindData()
            
        }
    }
    
    var images: [String]?
    var colour : [String]? = []
    var size: [String]? = []
    var variant : [Variants]?
    var variantModel: [VariantModel]?
    var vendor: String?
    var title: String?
    var price: String?
    var description: String?
    var isDataBound: Bool? = false
    
    var shoppingCartId: Int?

    
    
    var bindCustomProductDetailsViewModelToController: (() -> ()) = {}

    
    private func checkAndBindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.filteredProducts != nil || self.filteredCategory != nil || self.filteredSearch != nil {
                self.bindCustomProductDetailsViewModelToController()
            } else {
                self.checkAndBindData()
            }
        }
    }
    
    
    
    
    
    func getProduct(){
        
        if(ProductDetailsSharedData.instance.screenName == "Products"){
            brandsProducts()
            self.bindCustomProductDetailsViewModelToController()
        }else if(ProductDetailsSharedData.instance.screenName ==  "Category"){
            categoryProducts()
        }else if(ProductDetailsSharedData.instance.screenName == "Search" ){
            searchProducts()
            self.bindCustomProductDetailsViewModelToController()
        }else if(ProductDetailsSharedData.instance.screenName == "Favourite"){
            favouriteProducts()
            self.bindCustomProductDetailsViewModelToController()
        }
        
    //    self.bindCustomProductDetailsViewModelToController()

    }
    
    func brandsProducts(){
        filteredProducts = ProductDetailsSharedData.instance.filteredProducts ?? []
        print("PD FilterProducts count: \(filteredProducts?.count)")
        productFromArray = filteredProducts?[ProductDetailsSharedData.instance.brandsProductIndex ?? 0]
        
        variant = productFromArray?.variants ?? []
        if let variants = productFromArray?.variants {
            colour = Array(Set(variants.compactMap { $0.option2 }))
            size = Array(Set(variants.compactMap { $0.option1 }))
            price = variants.first?.price
            
             
            print("vm PD  variants.compactMap{ $0.option2} :\(variants.compactMap{ $0.option2} )")
            print("vm PD variants.compactMap { $0.option1 } :\(variants.compactMap { $0.option1 } )")
            print("vm PD variants.first?.price :\(variants.first?.price ?? "NOO PRICE")")
        }
        images = productFromArray?.images.compactMap{$0.src}
        vendor = productFromArray?.vendor
        title = productFromArray?.title
        description = productFromArray?.body_html
        print("vm PD filteredProdShared  :\(ProductDetailsSharedData.instance.filteredProducts ?? [])")
        print("vm PD  product?.variants ?? [] :\(productFromArray?.variants ?? [])")

        print("vm PD  product?.images.compactMap{$0.src} :\(productFromArray?.images.compactMap{$0.src} ?? [])")
        print("vm PD  product?.vendor :\(productFromArray?.vendor ?? "NOO VEND")")
        print("vm PD  product?.title :\(productFromArray?.title ?? "NOO TITl")")
        print("vm PD  product?.body_html :\(productFromArray?.body_html ?? "NO DESC" )")
        print("vm PD  index :\(ProductDetailsSharedData.instance.brandsProductIndex ?? 000)")
        
        
        let product = CustomProductDetails(images:images ?? [] , colour: colour ?? [], size: size ?? [], variant: variant ?? [], vendor: vendor ?? "No vendor", title: title ?? "No title", price: price ?? "No price", description: description ?? "No description")
    
        self.customProductDetails = product
        
        guard let productId = productFromArray?.id,
              let productTitle = productFromArray?.title,
              let productVendor = productFromArray?.vendor,
              let productImage = productFromArray?.images.first?.src else {
         
            return
        }

        
       addMultipleValuesToUserDefaults(productId: "\(productId)", productTitle: productTitle, productVendor: productVendor, productImage: productImage)
        
    }
    
    func categoryProducts(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.useFetchedData()
            self.bindCustomProductDetailsViewModelToController()
           
        }

    }
    
    
    
    func addToCart() {
        print("PD ScreenName: \(ProductDetailsSharedData.instance.screenName)")
        if(ProductDetailsSharedData.instance.screenName == "Category"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.useFetchedData()
                self.bindCustomProductDetailsViewModelToController()
                print("PD VariantId in addToCart: \(self.customProductDetails?.variant?.first?.id)")
                print("PD add to cart category")

                return
            }
        }
        
        print("PD VariantId: \(customProductDetails?.variant?.first?.id)")


        guard let customProductDetails = customProductDetails else {
            print("PD CustomProductDetails is nil")
            return
        }

        guard let firstVariantId = customProductDetails.variant?.first?.id else {
            print("PD No variant ID available")
            return
        }

        print("PD VariantId2 : \(firstVariantId)")
        postDraftOrder()
    }
    
    func searchProducts(){
        filteredSearch = ProductDetailsSharedData.instance.filteredSearch ?? []
        print("PD FilterSearch count: \(filteredSearch?.count)")
        productFromArray = filteredSearch?[ProductDetailsSharedData.instance.brandsProductIndex ?? 0]
        
        variant = productFromArray?.variants ?? []
        if let variants = productFromArray?.variants {
            colour = Array(Set(variants.compactMap { $0.option2 }))
            size = Array(Set(variants.compactMap { $0.option1 }))
            price = variants.first?.price
            
            
            print("vm PD  variants.compactMap{ $0.option2} :\(variants.compactMap{ $0.option2} )")
            print("vm PD variants.compactMap { $0.option1 } :\(variants.compactMap { $0.option1 } )")
            print("vm PD variants.first?.price :\(variants.first?.price ?? "NOO PRICE")")
        }
        images = productFromArray?.images.compactMap{$0.src}
        vendor = productFromArray?.vendor
        title = productFromArray?.title
        description = productFromArray?.body_html
        print("vm PD filteredProdShared  :\(ProductDetailsSharedData.instance.filteredSearch ?? [])")
        print("vm PD  product?.variants ?? [] :\(productFromArray?.variants ?? [])")

        print("vm PD  product?.images.compactMap{$0.src} :\(productFromArray?.images.compactMap{$0.src} ?? [])")
        print("vm PD  product?.vendor :\(productFromArray?.vendor ?? "NOO VEND")")
        print("vm PD  product?.title :\(productFromArray?.title ?? "NOO TITl")")
        print("vm PD  product?.body_html :\(productFromArray?.body_html ?? "NO DESC" )")
        print("vm PD  index :\(ProductDetailsSharedData.instance.brandsProductIndex ?? 000)")
        
        
        let product = CustomProductDetails(images:images ?? [] , colour: colour ?? [], size: size ?? [], variant: variant ?? [], vendor: vendor ?? "No vendor", title: title ?? "No title", price: price ?? "No price", description: description ?? "No description")
    
        self.customProductDetails = product
       
        guard let productId = productFromArray?.id,
              let productTitle = productFromArray?.title,
              let productVendor = productFromArray?.vendor,
              let productImage = productFromArray?.images.first?.src else {
         
            return
        }

        
       addMultipleValuesToUserDefaults(productId: "\(productId)", productTitle: productTitle, productVendor: productVendor, productImage: productImage)
    }
    
    func favouriteProducts(){
        
    }
    
    

    
    
    func postProduct(variantId: Int , quantity: Int , draftOrderId: Int){
        let urlString = APIConfig.draft_orders.url
        let draftOrder = draftOrder(variantId: variantId, quantity: quantity, draftOrderId: draftOrderId)
        
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .post, model: draftOrder, completion: { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case .success(let response):
                print("PD Draft order posted successfully: \(response)")
                DraftOrderSharedData.instance.draftOrder = response
            case .failure(let error):
                print("PD Failed to post draft order: \(error.localizedDescription)")
            }
        })
    }

    func useFetchedData() {
        if let data = ProductDetailsSharedData.instance.filteredCategory {
            print("Category Using data: \(data)")
            productModel = ProductDetailsSharedData.instance.filteredCategory
            print("Category productModel: \(productModel)")
            
            variantModel = productModel?.variants ?? []
            if let variants = productModel?.variants {
                colour = Array(Set(variants.compactMap { $0.option2 }))
                size = Array(Set(variants.compactMap { $0.option1 }))
                price = variants.first?.price
                
                
                print("vm PD  variants.compactMap{ $0.option2} :\(variants.compactMap{ $0.option2} )")
                print("vm PD variants.compactMap { $0.option1 } :\(variants.compactMap { $0.option1 } )")
                print("vm PD variants.first?.price :\(variants.first?.price ?? "NOO PRICE")")
            }
            images = productModel?.images.compactMap{$0.src}
            vendor = productModel?.vendor
            title = productModel?.title
            description = productModel?.body_html
            print("vm PD categoryProdShared  :\(ProductDetailsSharedData.instance.filteredCategory)")
            print("vm PD  product?.variants ?? [] :\(productModel?.variants ?? [])")

            print("vm PD  product?.images.compactMap{$0.src} :\(productModel?.images.compactMap{$0.src} ?? [])")
            print("vm PD  product?.vendor :\(productModel?.vendor ?? "NOO VEND")")
            print("vm PD  product?.title :\(productModel?.title ?? "NOO TITl")")
            print("vm PD  product?.body_html :\(productModel?.body_html ?? "NO DESC" )")
            print("vm PD  index :\(ProductDetailsSharedData.instance.brandsProductIndex ?? 000)")
            
            let product = CustomProductDetails(images:images ?? [] , colour: colour ?? [], size: size ?? [], variant: variant ?? [], vendor: vendor ?? "No vendor", title: title ?? "No title", price: price ?? "No price", description: description ?? "No description")
        
            self.customProductDetails = product
            
            guard let productId = productFromArray?.id,
                  let productTitle = productFromArray?.title,
                  let productVendor = productFromArray?.vendor,
                  let productImage = productFromArray?.images.first?.src else {
             
                return
            }

            
           addMultipleValuesToUserDefaults(productId: "\(productId)", productTitle: productTitle, productVendor: productVendor, productImage: productImage)
            
            if(isDataBound==true){
                postDraftOrder()
                isDataBound=false
            }
            
            
        } else {
            print("Category Data not available")
        }
    }





   @objc func dataDidUpdate() {
        if let data = ProductDetailsSharedData.instance.filteredCategory {
       
            print("SecondViewModel: Using data: \(data)")
            
            productModel = data
        } else {
            print("SecondViewModel: Data not available")
        }
   }

    

    
    func postDraftOrder() {

        if let savedShoppingCartId = UserDefaults.standard.string(forKey: Constants.shoppingCartId) {
            // Use the saved shoppingCartId
            print("xxx Retrieved shoppingCartId from UserDefaults: \(savedShoppingCartId)")
            
     
        } else {
            print("xxx shoppingCartId not found in UserDefaults")
            return
        }
  
        print("xxxx UD : \(UserDefaults.standard.string(forKey: Constants.shoppingCartId))")
        
        
        var draftOrderID = UserDefaults.standard.string(forKey: Constants.shoppingCartId) ?? "0"
        
        guard let draftOrderIDString = UserDefaults.standard.string(forKey: Constants.shoppingCartId) else {
            // Handle case where shoppingCartId is not available in UserDefaults
            print("xxx ShoppingCartId not found in UserDefaults")
            return
        }

        
        if let draftOrderIDString = UserDefaults.standard.string(forKey: Constants.shoppingCartId) {
          
            let cleanedString = draftOrderIDString.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            
           
            if let draftOrderIDInt = Int(cleanedString) {
             
                print("xxx draftOrderInt: \(draftOrderIDInt)")
                
                let urlString = APIConfig.endPoint("draft_orders/\(draftOrderIDInt)").url

                let productDraftOrder = self.draftOrder(variantId: self.customProductDetails?.variant?.first?.id ?? 0, quantity: 1, draftOrderId: draftOrderIDInt)
                
                print("yyy draftorderid: \(self.customProductDetails?.variant?.first?.id ?? 0)")
                
                    self.postDraftOrderNetwork(urlString: urlString, parameters: productDraftOrder)
               
            } else {
   
                print("xxx Failed to convert \(cleanedString) to Int")
            }
        } else {

            print("xxx ShoppingCartId not found in UserDefaults")
        }
        


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
    
    
    func draftOrder(variantId:Int, quantity: Int , draftOrderId: Int) -> [String:Any] {
        
        if(ProductDetailsSharedData.instance.screenName ==  "Category"){
            
            
          var variantLineItemId = UserDefaults.standard.string(forKey: Constants.variantId)
          print("zzz variantLineItemId: \(variantLineItemId)")
            
            let draftOrder: [String: Any] = [
                "draft_order": [
                    "id":draftOrderId ,
                    "line_items": [
                        [
                            "variant_id": variantLineItemId,
                            "quantity": quantity
                        ]
                    ]
                ]
            ]
            return draftOrder
            
        }else{
            let draftOrder: [String: Any] = [
                "draft_order": [
                    "id":draftOrderId ,
                    "line_items": [
                        [
                            "variant_id": variantId,
                            "quantity": quantity
                        ]
                    ]
                ]
            ]
            return draftOrder
        }
        
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


//    func deleteMultipleValuesFromUserDefaults(){
//        deleteValueFromUserDefaults(forKey: Constants.productId)
//        deleteValueFromUserDefaults(forKey: Constants.productTitle)
//        deleteValueFromUserDefaults(forKey: Constants.productVendor)
//        deleteValueFromUserDefaults(forKey: Constants.productImage)
//    }
    
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
