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
    
    var customerID: String?
    
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
                
                print("si: firebase firebase id user idddd view model: \(self?.user?.uid)")
                print("si: realtime database id : \(self?.customerID)")
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
    

    private func fetchCustomerID(for email: String) {
        authServiceProtocol.getCustomerId(forEmail: email) { [weak self] customerId in
            print("si: fetchCustomerId: \(customerId ?? "Nooo customer id found")")
            self?.customerID = customerId
            print("si: after getchCustomerId assign: \(customerId ?? "No customer id found")")
        }
    }

}









