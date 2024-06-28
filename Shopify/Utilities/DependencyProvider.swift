//
//  DependencyProvider.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation


class DependencyProvider {

    
    
    static var signInViewModel: SignInViewModel{
        return SignInViewModel()
    }
    
    static var userProfileViewModel: UserProfileViewModel{
        return UserProfileViewModel()
    }
    
    static var signUpViewModel: SignUpViewModel{
        return SignUpViewModel()
    }
    
    static var settingsViewModel: SettingsViewModel{
        return SettingsViewModel()
    }
    

    static var productDetailsViewModel: ProductDetailsViewModel{
        return ProductDetailsViewModel()
    }
    
    static var favouriteViewModel: FavouriteViewModel{
        return FavouriteViewModel()
    }


    
}
