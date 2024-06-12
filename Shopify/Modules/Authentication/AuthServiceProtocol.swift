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
//    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String)
    func saveCustomerId(name: String, email: String, customerId: String, favouriteId: String, shoppingCartId: String , productId: String , productTitle: String, productSize: String, productName: String, productImage: String)
    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void)
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFavouriteId(email: String)
    func fetchProducts(forCustomerId customerId: String, completion: @escaping ([CustomProduct]?) -> Void)
    func deleteProduct(forCustomerId customerId: String, productId: String) 
}
