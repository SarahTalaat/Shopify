//
//  ProductDetailsViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation


protocol ProductDetailsViewModelProtocol {
    var images: [String]? {get set}
    var colour : [String]? {get set}
    var size: [String]? {get set}
    var variant : [Variants]? {get set}
    var vendor: String? {get set}
    var title: String? {get set}
    var price: String? {get set}
    var description: String? {get set}
    var filteredProducts: [Products]? {get set}
    var customProductDetails: CustomProductDetails? {get set}
    var bindCustomProductDetailsViewModelToController: (() -> ()) {get set}
    func addToCart()
    func getProduct()
    var screenName: String? {get set}
   
}
