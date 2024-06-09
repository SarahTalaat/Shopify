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

}