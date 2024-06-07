//
//  SignInViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//


import Foundation
import FirebaseAuth

enum AuthErrorCode: Error {
    case wrongPassword
    case userNotFound
}
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
                print("user idddd view model: \(self?.user?.uid)")
            case .failure(let error):
                if let authError = error as? AuthErrorCode {
                    switch authError {
                    case .wrongPassword, .userNotFound:
                        self?.errorMessage = "Invalid email or password"
                    default:
                        self?.errorMessage = "An error occurred. Please try again later."
                    }
                } else {
                    self?.errorMessage = "An error occurred. Please try again later."
                }
            }
        }
    }
    
    
    
//    func signIn(email: String, password: String) {
//        authServiceProtocol.signIn(email: email, password: password) { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.user = user
//            case .failure(let error):
//                print("Firebase Error: \(error.localizedDescription)") // Print Firebase error message
//                print("Firebase Detailed Error: \(error)") // Print detailed error
//                self?.errorMessage = "An error occurred. Please try again later."
//            }
//        }
//    }
    
    
//    func signIn(email: String, password: String) {
//        authServiceProtocol.signIn(email: email, password: password) { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.user = user
//            case .failure(let error):
//                if error.localizedDescription == "The email address is badly formatted." || error.localizedDescription == "The password is invalid or the user does not have a password." {
//                    self?.errorMessage = "Incorrect data"
//                } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
//                    self?.errorMessage = "Email not found"
//                } else {
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
    



}









