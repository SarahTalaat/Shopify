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
            self?.fetchCustomerDataFromDatabase(customerID: customerId ?? "000000")
            print("si: after getchCustomerId assign: \(self?.customerID ?? "No customer id found")")
            

            
        }

    }
    
    func fetchCustomerDataFromDatabase(customerID: String) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        authServiceProtocol.getEmail(forCustomerId: customerID) { custEmail in
            if let custEmail = custEmail {
                print("custEmail: \(custEmail)")
            } else {
                print("Error: Failed to fetch email")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        authServiceProtocol.getName(forCustomerId: customerID) { custName in
            if let custName = custName {
                print("custName: \(custName)")
            } else {
                print("Error: Failed to fetch name")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        authServiceProtocol.getFavouriteId(forCustomerId: customerID) { custFavId in
            if let custFavId = custFavId {
                print("custFavId: \(custFavId)")
            } else {
                print("Error: Failed to fetch fav ID")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        authServiceProtocol.getShoppingCartId(forCustomerId: customerID) { custShopCartId in
            if let custShopCartId = custShopCartId {
                print("custShopCartId: \(custShopCartId)")
            } else {
                print("Error: Failed to fetch shopping cart ID")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All asynchronous tasks have completed")
        }
    }
}









