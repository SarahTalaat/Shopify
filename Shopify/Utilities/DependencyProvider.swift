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
        return SignInViewModel(authServiceProtocol: authServiceProtocol)
    }
    
    static var signUpViewModel: SignUpViewModel{
        return SignUpViewModel(authServiceProtocol: authServiceProtocol , networkServiceAuthenticationProtocol: networkServiceAuthenticationProtocol)
    }
    
    



    
}
