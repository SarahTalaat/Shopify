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
    
    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String) {
        let ref = Database.database().reference()
        let encodedEmail = SharedMethods.encodeEmail(email)
        let customersRef = ref.child("customers")
        let customerRef = customersRef.child(encodedEmail)
        
        let customerData: [String: Any] = [
            "customerId": id,
            "email": email,
            "name": name,
            "favouriteId" : favouriteId,
            "shoppingCartId": shoppingCartId
        ]
        
        customerRef.setValue(customerData) { error, _ in
            if let error = error {
                print("Error saving data to Firebase: \(error.localizedDescription)")
            } else {
                print("Data saved successfully to Firebase")
            }
        }
    }

    func getCustomerId(forEmail email: String, completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference()
        let encodedEmail = SharedMethods.encodeEmail(email)
        print("Firebase: encoded email: \(encodedEmail)")
        let customersRef = ref.child("customers").child(encodedEmail)
        
        customersRef.observeSingleEvent(of: .value) { snapshot in
            print("Firebase: Query snapshot value: \(snapshot.value ?? "No data")")
            
            guard let customerData = snapshot.value as? [String: Any] else {
                print("Firebase: No data found or error occurred")
                completion(nil)
                return
            }
           
            if let customerEmail = customerData["email"] as? String, customerEmail == email {
                if let customerId = customerData["customerId"] as? String {
                    print("Firebase: Matched customer ID for email: \(email)")
                    print("Firebase: Matched customer ID : \(customerId)")
                    completion(customerId)
                } else {
                    print("Firebase: Customer ID not found")
                    completion(nil)
                }
            } else {
                print("Firebase: No matching email found")
                completion(nil)
            }
        }
    }
    
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        let encodedEmail = SharedMethods.encodeEmail(email)
        let customersRef = ref.child("customers").child(encodedEmail)

        customersRef.observeSingleEvent(of: .value) { snapshot in
            let isTaken = snapshot.exists()
            completion(isTaken)
        }
    }

    func getEmail(forCustomerId customerId: String, completion: @escaping (String?) -> Void) {
            let ref = Database.database().reference().child("customers")
            ref.queryOrdered(byChild: "customerId").queryEqual(toValue: customerId).observeSingleEvent(of: .value) { snapshot in
                guard let customers = snapshot.value as? [String: Any],
                      let customerData = customers.values.first as? [String: Any],
                      let email = customerData["email"] as? String else {
                    completion(nil)
                    return
                }
                print("Firebase getEmail: \(email)")
                completion(email)
            }
        }
        
        func getName(forCustomerId customerId: String, completion: @escaping (String?) -> Void) {
            let ref = Database.database().reference().child("customers")
            ref.queryOrdered(byChild: "customerId").queryEqual(toValue: customerId).observeSingleEvent(of: .value) { snapshot in
                guard let customers = snapshot.value as? [String: Any],
                      let customerData = customers.values.first as? [String: Any],
                      let name = customerData["name"] as? String else {
                    completion(nil)
                    return
                }
                print("Firebase getName: \(name)")
                completion(name)
            }
        }
        
        func getFavouriteId(forCustomerId customerId: String, completion: @escaping (String?) -> Void) {
            let ref = Database.database().reference().child("customers")
            ref.queryOrdered(byChild: "customerId").queryEqual(toValue: customerId).observeSingleEvent(of: .value) { snapshot in
                guard let customers = snapshot.value as? [String: Any],
                      let customerData = customers.values.first as? [String: Any],
                      let favouriteId = customerData["favouriteId"] as? String else {
                    completion(nil)
                    return
                }
                print("Firebase getFavId: \(favouriteId)")
                completion(favouriteId)
            }
        }
        
        func getShoppingCartId(forCustomerId customerId: String, completion: @escaping (String?) -> Void) {
            let ref = Database.database().reference().child("customers")
            ref.queryOrdered(byChild: "customerId").queryEqual(toValue: customerId).observeSingleEvent(of: .value) { snapshot in
                guard let customers = snapshot.value as? [String: Any],
                      let customerData = customers.values.first as? [String: Any],
                      let shoppingCartId = customerData["shoppingCartId"] as? String else {
                    completion(nil)
                    return
                }
                print("Firebase getShoppingCartId: \(shoppingCartId)")
                completion(shoppingCartId)
            }
        }

}
