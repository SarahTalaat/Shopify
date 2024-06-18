//
//  ProductCellViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 17/06/2024.
//

import Foundation

protocol ProductsCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(index: Int)
    func productsCollectionViewCellDidToggleFavorite(at index: Int)
}
