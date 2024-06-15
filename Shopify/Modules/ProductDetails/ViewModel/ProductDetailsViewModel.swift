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
    
    var filteredProducts: [Products]? {
        didSet{
            self.bindCustomProductDetailsViewModelToController()
        }
    }
    
    var filteredCategory: ProductModel? {
        didSet{
            self.bindCustomProductDetailsViewModelToController()
        }
    }
    
    var filteredSearch: [Products]? {
        didSet{
            self.bindCustomProductDetailsViewModelToController()
        }
    }
    
    var product: Products?
    var productModel: ProductModel?
    
    var customProductDetails: CustomProductDetails? {
        didSet{
            self.bindCustomProductDetailsViewModelToController()
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
    
    
    var bindCustomProductDetailsViewModelToController: (() -> ()) = {}

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
        product = filteredProducts?[ProductDetailsSharedData.instance.brandsProductIndex ?? 0]
        
        variant = product?.variants ?? []
        if let variants = product?.variants {
            colour = Array(Set(variants.compactMap { $0.option2 }))
            size = Array(Set(variants.compactMap { $0.option1 }))
            price = variants.first?.price
            
            
            print("vm PD  variants.compactMap{ $0.option2} :\(variants.compactMap{ $0.option2} )")
            print("vm PD variants.compactMap { $0.option1 } :\(variants.compactMap { $0.option1 } )")
            print("vm PD variants.first?.price :\(variants.first?.price ?? "NOO PRICE")")
        }
        images = product?.images.compactMap{$0.src}
        vendor = product?.vendor
        title = product?.title
        description = product?.body_html
        print("vm PD filteredProdShared  :\(ProductDetailsSharedData.instance.filteredProducts ?? [])")
        print("vm PD  product?.variants ?? [] :\(product?.variants ?? [])")

        print("vm PD  product?.images.compactMap{$0.src} :\(product?.images.compactMap{$0.src} ?? [])")
        print("vm PD  product?.vendor :\(product?.vendor ?? "NOO VEND")")
        print("vm PD  product?.title :\(product?.title ?? "NOO TITl")")
        print("vm PD  product?.body_html :\(product?.body_html ?? "NO DESC" )")
        print("vm PD  index :\(ProductDetailsSharedData.instance.brandsProductIndex ?? 000)")
        
        
        let product = CustomProductDetails(images:images ?? [] , colour: colour ?? [], size: size ?? [], variant: variant ?? [], vendor: vendor ?? "No vendor", title: title ?? "No title", price: price ?? "No price", description: description ?? "No description")
    
        self.customProductDetails = product
    }
    
    func categoryProducts(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.useFetchedData()
            self.bindCustomProductDetailsViewModelToController()
        }
//        productModel = ProductDetailsSharedData.instance.filteredCategory

    }
    
    
    func searchProducts(){
        filteredSearch = ProductDetailsSharedData.instance.filteredSearch ?? []
        print("PD FilterSearch count: \(filteredSearch?.count)")
        product = filteredSearch?[ProductDetailsSharedData.instance.brandsProductIndex ?? 0]
        
        variant = product?.variants ?? []
        if let variants = product?.variants {
            colour = Array(Set(variants.compactMap { $0.option2 }))
            size = Array(Set(variants.compactMap { $0.option1 }))
            price = variants.first?.price
            
            
            print("vm PD  variants.compactMap{ $0.option2} :\(variants.compactMap{ $0.option2} )")
            print("vm PD variants.compactMap { $0.option1 } :\(variants.compactMap { $0.option1 } )")
            print("vm PD variants.first?.price :\(variants.first?.price ?? "NOO PRICE")")
        }
        images = product?.images.compactMap{$0.src}
        vendor = product?.vendor
        title = product?.title
        description = product?.body_html
        print("vm PD filteredProdShared  :\(ProductDetailsSharedData.instance.filteredSearch ?? [])")
        print("vm PD  product?.variants ?? [] :\(product?.variants ?? [])")

        print("vm PD  product?.images.compactMap{$0.src} :\(product?.images.compactMap{$0.src} ?? [])")
        print("vm PD  product?.vendor :\(product?.vendor ?? "NOO VEND")")
        print("vm PD  product?.title :\(product?.title ?? "NOO TITl")")
        print("vm PD  product?.body_html :\(product?.body_html ?? "NO DESC" )")
        print("vm PD  index :\(ProductDetailsSharedData.instance.brandsProductIndex ?? 000)")
        
        
        let product = CustomProductDetails(images:images ?? [] , colour: colour ?? [], size: size ?? [], variant: variant ?? [], vendor: vendor ?? "No vendor", title: title ?? "No title", price: price ?? "No price", description: description ?? "No description")
    
        self.customProductDetails = product
    }
    
    func favouriteProducts(){
        
    }
    
    
    func draftOrder(variantId: Int, quantity: Int ) -> [String:Any] {
        let draftOrder: [String:Any] = [
            "draft_order": [
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
    
    
    func postProduct(variantId: Int , quantity: Int){
        let urlString = APIConfig.draft_orders.url
        let draftOrder = draftOrder(variantId: variantId, quantity: quantity)
        
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
            
        } else {
            print("Category Data not available")
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidUpdate), name: .filteredCategoryDidUpdate, object: nil)
    }



    deinit {
            NotificationCenter.default.removeObserver(self, name: .filteredCategoryDidUpdate, object: nil)
        }
        
   @objc func dataDidUpdate() {
        if let data = ProductDetailsSharedData.instance.filteredCategory {
            // Use the data if needed
            print("SecondViewModel: Using data: \(data)")
            
            // Example: Update the productModel if needed
            productModel = data
        } else {
            print("SecondViewModel: Data not available")
        }
   }
}
