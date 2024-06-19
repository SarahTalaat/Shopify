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
        if DependencyProvider.userProfileViewModel.name == "Guest"{
            showGuestAlert()
        }else{
            print("Cart ")
            guard let viewController = viewController else {
                return
            }
            
            
            let storyboard = UIStoryboard(name: "Third", bundle: nil)
            let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartViewController
            viewController.navigationController?.pushViewController(brandsViewController, animated: true)
        }
    }
    
    @objc func navToFav() {
        if DependencyProvider.userProfileViewModel.name == "Guest"{
            showGuestAlert()
        }else{
            print("Favourite ")
            guard let viewController = viewController else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
            viewController.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
    @objc func navToSettings() {
        if  DependencyProvider.userProfileViewModel.name == "Guest"{
            showGuestAlert()
        }else{
            guard let viewController = viewController else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Third", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsScreenViewController
            viewController.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }

    static func encodeEmail(_ email: String) -> String {
        return email
            .replacingOccurrences(of: ".", with: ",")
            .replacingOccurrences(of: "#", with: "_hash_")
            .replacingOccurrences(of: "$", with: "_dollar_")
            .replacingOccurrences(of: "[", with: "_leftbracket_")
            .replacingOccurrences(of: "]", with: "_rightbracket_")
            .replacingOccurrences(of: "@", with: "_at_")
    }
    
    static func decodeEmail(_ encodedEmail: String) -> String {
        return encodedEmail
            .replacingOccurrences(of: "_at_", with: "@")
            .replacingOccurrences(of: "_rightbracket_", with: "]")
            .replacingOccurrences(of: "_leftbracket_", with: "[")
            .replacingOccurrences(of: "_dollar_", with: "$")
            .replacingOccurrences(of: "_hash_", with: "#")
            .replacingOccurrences(of: ",", with: ".")
    }
    
    private func showGuestAlert() {
           guard let viewController = viewController else { return }
           
           let alert = UIAlertController(title: "Guest Access Restricted", message: "Please sign in to access this feature.", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(okAction)
           
           viewController.present(alert, animated: true, completion: nil)
       }
    
}
