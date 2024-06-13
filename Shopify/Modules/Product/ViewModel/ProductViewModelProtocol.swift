//
//  ProductViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 13/06/2024.
//

import Foundation


protocol ProductViewModelProtocol {
    var authServiceProtocol: AuthServiceProtocol! { get }
    func addProductToFavorites(productId: String, title: String, option1: String, option2: String, src: String)
    func deleteProduct(productId: String)
    func isFavorite(productId: String) -> Bool
}
