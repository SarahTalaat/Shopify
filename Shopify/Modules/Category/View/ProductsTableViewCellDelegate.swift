//
//  ProductsTableViewCellDelegate.swift
//  Shopify
//
//  Created by Sara Talat on 18/06/2024.
//

import Foundation


protocol ProductsTableViewCellDelegate {
    func didTapFavoriteButtons(index: Int)
    func productsTableViewCellDidToggleFavorite(at index: Int)
}
