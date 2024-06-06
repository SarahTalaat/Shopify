//
//  FirebaseAuthService.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService: AuthServiceProtocol {
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.handleAuthResult(result: result, error: error, completion: completion)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.handleAuthResult(result: result, error: error, completion: completion)
        }
    }
    
    private func handleAuthResult(result: AuthDataResult?, error: Error?, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let user = result?.user else {
            // Handle the case where user is nil but no error was provided
            let unknownError = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
            completion(.failure(unknownError))
            return
        }
        let userModel = UserModel(uid: user.uid, email: user.email ?? "")
        completion(.success(userModel))
    }
}
