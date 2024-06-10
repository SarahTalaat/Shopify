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
    
    var customerID: String? {
        didSet{
            self.bindUserViewModelToController()
            fetchCustomerID()
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
                self?.fetchCustomerID()
                print("si: firebase firebase id user idddd view model: \(self?.user?.uid)")
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
    

    private func fetchCustomerID() {
        guard let email = user?.email else {
            print("User email is nil")
            return
        }
        authServiceProtocol.getCustomerId(forEmail: email) { [weak self] customerId in
            print("si: fetchCustomerId: \(customerId ?? "No customer id found")")
            self?.customerID = customerId
            self?.fetchCustomerDataFromDatabase(customerID: self?.customerID ?? "000000000" )
            print("si: after getchCustomerId assign: \(customerId ?? "No customer id found")")
            

            
        }

    }
    
    func fetchCustomerDataFromDatabase(customerID: String){
        var custEmail = authServiceProtocol.getEmail(forCustomerId: customerID, completion: { custEmail in
            print("custEmail: \(custEmail ?? "No email found")")
            
        })
        print(" ")
        var custFavId = authServiceProtocol.getName(forCustomerId: customerID, completion: { custFavId in
            print("custFavId: \(custFavId ?? "No favourite ID found")")
            
        })

        print(" ")
        
        var custShopCartId = authServiceProtocol.getShoppingCartId(forCustomerId: customerID, completion: { custShopCartId in
            print("custShopCartId: \(custShopCartId ?? "No shopping cart ID found")")
            
        })
        
        print(" ")
        
        var custName = authServiceProtocol.getName(forCustomerId: customerID, completion: { custName in
            print("custName: \(custName ?? "No name found")")
        })

        print(" ")
        
    }
    
}









