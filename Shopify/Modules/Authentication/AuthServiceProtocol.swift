//
//  AuthServiceProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol  {
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String)
    func getCustomerId(forEmail email: String, completion: @escaping (String?) -> Void)
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void)
    
    func getEmail(forCustomerId customerId: String, completion: @escaping (String?) -> Void)
   func getName(forCustomerId customerId: String, completion: @escaping (String?) -> Void)
   func getFavouriteId(forCustomerId customerId: String, completion: @escaping (String?) -> Void)
   func getShoppingCartId(forCustomerId customerId: String, completion: @escaping (String?) -> Void)

}
