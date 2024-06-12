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
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                let unknownError = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                completion(.failure(unknownError))
                return
            }

            self?.checkEmailVerification(for: user) { isVerified, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if isVerified {
                    let userModel = UserModel(uid: user.uid, email: user.email ?? "")
                    completion(.success(userModel))
                } else {
                    completion(.failure(AuthErrorCode.emailNotVerified))
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }

    
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard self != nil else { return }
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                let unknownError = NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                completion(.failure(unknownError))
                return
            }

            // Send verification email
            user.sendEmailVerification { error in
                if let error = error {
                    print("Firebase: Error sending verification email: \(error.localizedDescription)")
                } else {
                    print("Firebase: Verification email sent successfully.")
                }
            }

            let userModel = UserModel(uid: user.uid, email: user.email ?? "")
            print("Firebase: The user iddd: \(userModel.uid)")
            completion(.success(userModel))
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
    func checkEmailVerification(for user: User, completion: @escaping (Bool, Error?) -> Void) {
        user.reload { error in
            if let error = error {
                completion(false, error)
                return
            }
            completion(user.isEmailVerified, nil)
        }
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

    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
        let ref = Database.database().reference()
        let encodedEmail = SharedMethods.encodeEmail(email)
        let customersRef = ref.child("customers").child(encodedEmail)
        
        customersRef.observeSingleEvent(of: .value) { snapshot in
            guard let customerData = snapshot.value as? [String: Any] else {
                print("Firebase: No data found or error occurred")
                completion(nil)
                return
            }
            
            if let customerEmail = customerData["email"] as? String, customerEmail == email {
                guard let customerId = customerData["customerId"] as? String,
                      let name = customerData["name"] as? String,
                      let favouriteId = customerData["favouriteId"] as? String,
                      let shoppingCartId = customerData["shoppingCartId"] as? String else {
                    print("Firebase: Missing data for the customer")
                    completion(nil)
                    return
                }
                
                let customer = CustomerData(customerId: customerId, name: name, email: email, favouriteId: favouriteId, shoppingCartId: shoppingCartId)
                print("Firebase: customer: \(customer)")
                print("Firebase: Customer data fetched successfully")
                completion(customer)
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

}

//    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
//            self?.handleAuthResult(result: result, error: error, completion: completion)
//        }
//
//
//    }
    
//    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            self?.handleAuthResult(result: result, error: error, completion: completion)
//        }
//    }


//    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
//            self?.handleAuthResult(result: result, error: error, completion: completion)
//        }
//
//
//    }
//
//    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            self?.handleAuthResult(result: result, error: error, completion: completion)
//        }
//    }
    
