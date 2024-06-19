//
//  FavouriteViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 16/06/2024.
//

import Foundation


protocol FavouriteViewModelProtocol {
    func retriveProducts()
    var bindProducts:(()->()) {get set}
    var products: [ProductFromFirebase]? {get set}
    func deleteProductFromFirebase(index: Int)
    func getproductId(index: Int)
}
