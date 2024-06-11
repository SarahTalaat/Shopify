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
    var name: String?
    var email: String?
    var favId: String?
    var shopCartId: String?
    
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
    

//    private func fetchCustomerID() {
//        guard let email = user?.email else {
//            print("User email is nil")
//            return
//        }
//        authServiceProtocol.getCustomerId(forEmail: email) { [weak self] customerId in
//            print("si: fetchCustomerId: \(customerId ?? "No customer id found")")
//
//            SharedDataRepository.instance.customerId = customerId
//            self?.fetchCustomerDataFromDatabase(customerID: customerId ?? "000000")
//            print("si: after getchCustomerId assign: \(self?.customerID ?? "No customer id found")")
//
//
//
//        }
//
//    }
    
    private func fetchCustomerID(){
        
        guard let email = user?.email else {
            print("User email is nil")
            return
        }
        
        authServiceProtocol.fetchCustomerDataFromRealTimeDatabase(forEmail: email){
            [weak self] customerDataModel in
            
            print("si: param email: \(email)")
            print("si: customerDataModel: \(customerDataModel ?? CustomerData(customerId: "NOOOID", name: "NOOOName", email: "NOOOEmail", favouriteId: "NOOOFavID", shoppingCartId: "NOOOShoppingID"))")
            SharedDataRepository.instance.customerName = customerDataModel?.name
            SharedDataRepository.instance.customerId = customerDataModel?.customerId
            SharedDataRepository.instance.shoppingCartId = customerDataModel?.shoppingCartId
            SharedDataRepository.instance.favouriteId = customerDataModel?.favouriteId
            
            print("si: inside: name: \(SharedDataRepository.instance.customerName ?? "NONAME")")
            print("si: inside email: \(SharedDataRepository.instance.customerEmail ?? "NOEMAIL")")
            print("si: inside: Cid: \(SharedDataRepository.instance.customerId ?? "NO CID")")
            print("si: inside: favId: \(SharedDataRepository.instance.favouriteId ?? "NO FID")")
            print("si: inside: shoppingCartId: \(SharedDataRepository.instance.shoppingCartId ?? "NO ShopID")")
        }
        SharedDataRepository.instance.customerEmail = user?.email
        
//        print("si: outside: name: \(SharedDataRepository.instance.customerName ?? "NONAME")")
//        print("si: outside: email: \(SharedDataRepository.instance.customerEmail ?? "NOEMAIL")")
//        print("si: outside: Cid: \(SharedDataRepository.instance.customerId ?? "NO CID")")
//        print("si: outside: favId: \(SharedDataRepository.instance.favouriteId ?? "NO FID")")
//        print("si: outside: shoppingCartId: \(SharedDataRepository.instance.shoppingCartId ?? "NO ShopID")")
        
    }
    


}









