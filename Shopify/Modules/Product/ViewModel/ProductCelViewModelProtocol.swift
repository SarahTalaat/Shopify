//
//  ProductCelViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 13/06/2024.
//

import Foundation

import Foundation

protocol ProductCellViewModelProtocol {
    var productId: String { get }
    var productTitle: String { get }
    var option1: String { get }
    var option2: String { get }
    var src: String { get }
    var isFavorite: Bool { get set }
    var addToFavoriteAction: (() -> Void)? { get set }
}
