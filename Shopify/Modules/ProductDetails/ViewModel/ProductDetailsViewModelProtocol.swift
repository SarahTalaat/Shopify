//
//  ProductDetailsViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation


protocol ProductDetailsViewModelProtocol {
    var draftOrderDetails: OneDraftOrderResponse? {get set}
    var productDetails: GetProductResponse? {get set}
    var bindProductDetailsViewModelToController: (() -> ()) {get set}
    func getProductDetails()
    func addToCart()
    func getColourArray(variants:[GetVariant])-> [String]
    func getsizeArray(variants:[GetVariant])-> [String]
   
}
