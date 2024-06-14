//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    
 
    
    init(){
        
    }
    
    var filteredProducts: [Products]? {
        didSet{
            self.bindCustomProductDetailsViewModelToController()
        }
    }
    var product: Products?
    
    var customProductDetails: CustomProductDetails? {
        didSet{
            self.bindCustomProductDetailsViewModelToController()
        }
    }
    
    var images: [String]?
    var colour : [String]? = []
    var size: [String]? = []
    var variant : [Variants]?
    var vendor: String?
    var title: String?
    var price: String?
    var description: String?
    
    
    var bindCustomProductDetailsViewModelToController: (() -> ()) = {}

    func getProduct(){
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
        self.bindCustomProductDetailsViewModelToController()

    }
    
    
}
