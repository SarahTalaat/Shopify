//
//  ProductDetailsViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation


protocol ProductDetailsViewModelProtocol {
    
    func isGuest()->Bool?
    func saveAddedToCartStateShoppingCart(_ added: Bool , productId:Int) 
    func saveButtonTitleStateShoppingCart(addToCartUI:CustomButton , productId:Int)
    func deleteProductFromShoppingCart(productId:Int)
    var exchangeRates: [String: Double] {get set}
    func inventoryQuantityLabel() -> String 
    func fetchExchangeRates()
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
    func deleteFromCart()
    func getUserDraftOrderId()
    func getCartId()
    func saveAddedToCartState(_ added: Bool)
    func saveButtonTitleState(addToCartUI:CustomButton)
    func getCustomerIdFromFirebase()
}
