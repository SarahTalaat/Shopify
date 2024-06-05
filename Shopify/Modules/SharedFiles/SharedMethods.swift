//
//  SharedMethods.swift
//  Shopify
//
//  Created by Sara Talat on 03/06/2024.
//

import Foundation
import UIKit

class SharedMethods{
    
    weak var viewController: UIViewController?
        
    var sharedMethods: SharedMethods?
    
    init(viewController: UIViewController) {
            self.viewController = viewController
    }
    
    @objc func navToCart() {
        print("Cart ")
        guard let viewController = viewController else {
            return
        }

        let storyboard = UIStoryboard(name: "Third", bundle: nil)
        let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartViewController
        viewController.navigationController?.pushViewController(brandsViewController, animated: true)
    }
    
    @objc func navToFav() {
        print("Favourite ")
        guard let viewController = viewController else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        viewController.navigationController?.pushViewController(favouriteVC, animated: true)
    }
    @objc func navToSettings() {
        guard let viewController = viewController else {
            return
        }

        let storyboard = UIStoryboard(name: "Third", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsScreenViewController
        viewController.navigationController?.pushViewController(settingsVC, animated: true)
    }

    
}
