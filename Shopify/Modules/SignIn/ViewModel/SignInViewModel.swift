//
//  SignInViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//


import Foundation

class SignInViewModel: SignInViewModelProtocol {
    
    let authServiceProtocol: AuthServiceProtocol
    
    var user: UserModel? {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.bindErrorViewModelToController()
        }
    }
    
    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
    init(authServiceProtocol: AuthServiceProtocol) {
        self.authServiceProtocol = authServiceProtocol
    }
    
    
    
    func signIn(email: String, password: String) {
        authServiceProtocol.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                if error.localizedDescription == "The email address is badly formatted." || error.localizedDescription == "The password is invalid or the user does not have a password." {
                    self?.errorMessage = "Incorrect data"
                } else {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}
