//
//  ProductCellViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 13/06/2024.
//

import Foundation


struct ProductCellViewModel: ProductCellViewModelProtocol {
    let productId: String
    let productTitle: String
    let option1: String
    let option2: String
    let src: String
    var isFavorite: Bool
    var addToFavoriteAction: (() -> Void)?
}
