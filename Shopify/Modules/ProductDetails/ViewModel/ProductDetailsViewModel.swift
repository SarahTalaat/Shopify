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
    
    var filteredProducts: [Products]?
    var product: Products?
    
    var customProductDetails: CustomProductDetails? {
        didSet{
            bindCustomProductDetailsViewModelToController()
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
        
        product = filteredProducts?[ProductDetailsSharedData.instance.brandsProductIndex ?? 0]
        variant = product?.variants ?? []
        if let variants = product?.variants {
            colour = variants.compactMap{ $0.option2}
            size = variants.compactMap { $0.option1 }
            price = variants.first?.price
        }
        images = product?.images.compactMap{$0.src}
        vendor = product?.vendor
        title = product?.title
        description = product?.body_html
        
        customProductDetails = CustomProductDetails(images:images ?? [] , colour: colour ?? [], size: size ?? [], variant: variant ?? [], vendor: vendor ?? "No vendor", title: title ?? "No title", price: price ?? "No price", description: description ?? "No description")
    
    }
    
    
}
