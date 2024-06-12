//
//  SettingsViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 12/06/2024.
//

import Foundation

class SettingsViewModel: SettingsViewModelProtocol{
    
    let authServiceProtocol: AuthServiceProtocol
    
    init(authServiceProtocol: AuthServiceProtocol) {
        self.authServiceProtocol = authServiceProtocol
    }
    
    var errorMessage: String? {
        didSet {
            print("vm Error message updated: \(String(describing: errorMessage))")
            bindErrorViewModelToController()
        }
    }
    
    var isSignedOut: Bool? {
        didSet {
            print("vm SignOut true")
            bindLogOutStatusViewModelToController()
        }
    }
    
    var bindLogOutStatusViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
 
    func signOut(isSignedOut: Bool) {
        print("print signOut")
        authServiceProtocol.signOut { result in
            switch result {
            case .success:
                print("User signed out successfully")
                self.isSignedOut = isSignedOut
                SharedDataRepository.instance.isSignedIn = false
            case .failure(let error):

                print("Failed to sign out: \(error.localizedDescription)")
                self.handleSignUpError(error)

            }
        }
    }
    
    
    func handleSignUpError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
