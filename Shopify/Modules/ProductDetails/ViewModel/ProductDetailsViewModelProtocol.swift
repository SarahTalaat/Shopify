//
//  ProductDetailsViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation


protocol ProductDetailsViewModelProtocol {

    var product: ProductResponseFromApi? {get set}
    var bindProductDetailsViewModelToController: (() -> ()) {get set}
    func getProductDetails()
    func addToCart()
    func addProductToFirebase()
    func deleteProductFromFirebase()
    func getSizeCount()->Int
    func getColoursCount()->Int
    func getColour(index:Int) -> String
    func getsize(index:Int) -> String
    
}
