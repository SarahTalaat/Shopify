//
//  FirebaseAuthService.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

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
        print("The user iddd: \(userModel.uid)")
        completion(.success(userModel))
    }
    
    func saveCustomerId(email: String, id: String) {

        // Get a reference to your Firebase Realtime Database
        let ref = Database.database().reference()

        // Specify the path where you want to save the data
        let customersRef = ref.child("customers")

        // Create a child node with the unique key
        let customerRef = customersRef.child("customerData")

        // Create a dictionary to hold the data you want to save
        let customerData: [String: Any] = [
            "customerId": id,
            "email": email
            // Add more data if needed
        ]

        // Save the data to the specified location in the database
        customerRef.setValue(customerData) { error, _ in
            if let error = error {
                print("Error saving data to Firebase: \(error.localizedDescription)")
            } else {
                print("Data saved successfully to Firebase")
            }
        }
    }


    
    
}
