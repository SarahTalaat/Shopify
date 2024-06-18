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
    case emailNotVerified
}
class SignInViewModel: SignInViewModelProtocol {

    
    
    static let sharedDataUpdateQueue = DispatchQueue(label: "com.Shopify.sharedDataUpdateQueue")

    let authServiceProtocol: AuthServiceProtocol
    let networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol
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
    
    init(authServiceProtocol: AuthServiceProtocol, networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol) {
        self.authServiceProtocol = authServiceProtocol
        self.networkServiceAuthenticationProtocol = networkServiceAuthenticationProtocol
    }
    
    func signIn(email: String, password: String) {
        
        
            self.authServiceProtocol.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.fetchCustomerID()
                SharedDataRepository.instance.customerEmail = email
                self?.addValueToUserDefaults(value: email, forKey: Constants.customerEmail)
                print("ddd 1.")
                self?.checkEmailSignInStatus(email:email)
                print("ddd 2.")
               // self?.updateSignInStatus(email: email)
                print("ddd 3.")
                
            case .failure(let error):
                if let authError = error as? AuthErrorCode {
                    switch authError {
                    case .wrongPassword, .userNotFound:
                        self?.errorMessage = "Invalid email or password"
                    case .emailNotVerified:
                        self?.errorMessage = "Email not verified. Please check your email for a verification link."
                    default:
                        self?.errorMessage = "An error occurred. Please try again later."
                    }
                } else {
                    self?.errorMessage = "An error occurred. Please try again later."
                }
            }
        }
      
    }
    func updateSignInStatus(email:String){
        authServiceProtocol.updateSignInStatus(email: email, isSignedIn: "\(true)") { success in
            if success {
                print("Sign-in status updated successfully.")
            } else {
                print("Failed to update sign-in status.")
            }
        }
        
    }
    
    func checkEmailSignInStatus(email:String){

        authServiceProtocol.checkEmailSignInStatus(email:email) { isSignedIn in
            if isSignedIn == true {
                print("Email is signed in no post will happen for draft order: \(isSignedIn)")

            } else {
                
                let urlString = APIConfig.draft_orders.url
                let draftOrder1 = self.draftOrderDummyModel1()
                
                self.postDraftOrderForShoppingCart(urlString: urlString, parameters: draftOrder1 ?? [:], name: SharedDataRepository.instance.customerName ?? "NameXX", email: SharedDataRepository.instance.customerEmail ?? "EmailXX") { [weak self] shoppingCartIdString in
                    
                    guard let shoppingCartIdString = shoppingCartIdString else {
                        
                            return
                        }
                        
                        // Extract the actual shoppingCartId from the string representation
                        if let range = shoppingCartIdString.range(of: "Optional(") {
                            let shoppingCartId = shoppingCartIdString.replacingCharacters(in: range, with: "")
                                .replacingOccurrences(of: ")", with: "")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            UserDefaults.standard.set(shoppingCartId, forKey: Constants.shoppingCartId)
                        }
                    print("si: UD DrafId \(UserDefaults.standard.string(forKey: Constants.shoppingCartId ?? ""))")
                }//post
                self.updateSignInStatus(email: email)
                

            }//else isSignedIn false
            
            SharedDataRepository.instance.isSignedIn = true
            print("si: firebase firebase id user idddd view model: \(self.user?.uid)")
        }//signin
        
    }
    
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
        
        
    }
    
    func postDraftOrderForShoppingCart(urlString: String, parameters: [String:Any], name: String, email: String, completion: @escaping (String?) -> Void) {
        networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method:.post, model: parameters, completion: { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case.success(let response):
                print("MAIN response id: \(response.draftOrder?.id) ")
                let shoppingCartId = "\(response.draftOrder?.id)"
                if let draftOrerId = response.draftOrder?.id {
                    let draftOrderIdString = "\(draftOrerId)"
                    UserDefaults.standard.set( draftOrderIdString, forKey: Constants.draftOrderId)
                    UserDefaults.standard.synchronize()
                    
                }
                completion(shoppingCartId) // Call the completion handler with the shoppingCartId value
            case.failure(let error):
                print("si Failed to post draft order: \(error.localizedDescription)")
                completion(nil)
            }
        })
    }
    func useShoppingCartId(_ shoppingCartId: String) {
        // Use the shoppingCartId value here
        SharedDataRepository.instance.shoppingCartId = shoppingCartId
        print("si useShop: \(SharedDataRepository.instance.shoppingCartId)")
        print("si: Using shoppingCartId: \(shoppingCartId)")
    }
    
    func postDraftOrderForFavourite(urlString: String, parameters: [String:Any], name: String , email: String) {
       networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .post, model: parameters, completion: { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case .success(let response):
                print("si Draft order posted successfully: \(response)")
                SharedDataRepository.instance.favouriteId = "\(response.draftOrder?.id)"
                print("si: FavouriteId: \(SharedDataRepository.instance.favouriteId)")
            case .failure(let error):
                print("si Failed to post draft order: \(error.localizedDescription)")
            }
        })
    }
    
    
    func draftOrderDummyModel1() -> [String:Any] {
        let draftOrder: [String: Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": 44382096457889,
                        "quantity": 1
                    ]
                ]
            ]
        ]
        
        return draftOrder
    }
    
    func draftOrderDummyModel2() -> [String:Any] {
        let draftOrder: [String:Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": 44382094393505,
                        "quantity": 1
                    ]
                ]
            ]
        ]
        
        return draftOrder
    }
    func addValueToUserDefaults(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    func setDraftOrderId(email:String, shoppingCartID:String){
        authServiceProtocol.setShoppingCartId(email: email, shoppingCartId: shoppingCartID) { error in
            if let error = error {
                print("Failed to set shopping cart ID: \(error.localizedDescription)")
            } else {
                print("Shopping cart ID set successfully!")
            }
        }
    }
    
    func getDraftOrderID(email:String){
        authServiceProtocol.getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                print("Failed to retrieve shopping cart ID: \(error.localizedDescription)")
            } else if let shoppingCartId = shoppingCartId {
                print("Shopping cart ID found: \(shoppingCartId)")
            } else {
                print("No shopping cart ID found for this user.")
            }
        }
    }
    
    
    

}






/*
 let json: [String: Any] = [
     "draft_order": [
         "line_items": [
             [
                 "variant_id": 44382094393505,
                 "quantity": 1
             ]
         ]
     ]
 ]
 */
