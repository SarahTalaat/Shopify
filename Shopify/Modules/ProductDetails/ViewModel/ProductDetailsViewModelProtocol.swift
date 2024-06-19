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
    func getSizeCount() -> Int
    func getColoursCount() -> Int
    func getColour(index: Int) -> String?
    func getSize(index: Int) -> String?
    func loadFavoriteProducts()
    func saveFavoriteProducts()
    func checkIfFavorited() -> Bool
    func toggleFavorite()
    var isFavorited: Bool {get set}
    func deleteDraftOrderNetwork(urlString: String, parameters: [String:Any])
    func deleteFromCart()
    
}
