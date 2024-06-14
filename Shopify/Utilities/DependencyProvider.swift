//
//  DependencyProvider.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation


class DependencyProvider {
    
    static var authServiceProtocol : AuthServiceProtocol {
        return FirebaseAuthService()
    }
    
    static var networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol {
        return NetworkServiceAuthentication()
    }
    
    static var signInViewModel: SignInViewModel{
        return SignInViewModel(authServiceProtocol: authServiceProtocol , networkServiceAuthenticationProtocol: networkServiceAuthenticationProtocol)
    }
    
    static var userProfileViewModel: UserProfileViewModel{
        return UserProfileViewModel()
    }
    
    static var signUpViewModel: SignUpViewModel{
        return SignUpViewModel(authServiceProtocol: authServiceProtocol , networkServiceAuthenticationProtocol: networkServiceAuthenticationProtocol)
    }
    
    static var settingsViewModel: SettingsViewModel{
        return SettingsViewModel(authServiceProtocol: authServiceProtocol)
    }
    
    static var productDetails: ProductDetailsViewModel{
        return ProductDetailsViewModel()
    }
    



    
}
