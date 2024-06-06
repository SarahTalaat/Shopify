//
//  SignInViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//


import Foundation

class SignInViewModel {
    private let authService: AuthServiceProtocol
    
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
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func signIn(email: String, password: String) {
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
