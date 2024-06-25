////
////  SignInVM.swift
////  ShopifyTests
////
////  Created by Sara Talat on 25/06/2024.
////
//
//import Foundation
//@testable import Shopify
//
//class MockAuthService {
//    var signInResult: Result<UserModel, Error>?
//    var updateSignInStatusSuccess: Bool = true
//    var checkEmailSignInStatusResult: Bool = true
//    var fetchCustomerDataResult: CustomerData?
//
//    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        if let result = signInResult {
//            completion(result)
//        }
//    }
//    func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
//        // Simulate the completion based on the mock's success flag
//        completion(updateSignInStatusSuccess)
//    }
//
//    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
//        // Mock sign-out if needed
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            completion(.success(()))
//        }
//    }
//
//    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        // Mock sign-up if needed
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            let user = UserModel(uid: "mockedUid", email: email)
//            completion(.success(user))
//        }
//    }
//    func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
//        completion(checkEmailSignInStatusResult)
//    }
//
//    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
//        completion(fetchCustomerDataResult)
//    }
//
//    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
//        // Mock email check if needed
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            let isTaken = email.contains("@taken.com") // Mock logic to check if email is taken
//            completion(isTaken)
//        }
//    }
//
//    func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
//        // Mock shopping cart ID setting if needed
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            completion(nil) // Simulate success
//        }
//    }
//
//    func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
//        // Mock shopping cart ID retrieval if needed
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            let shoppingCartId = "mockedShoppingCartId"
//            completion(shoppingCartId, nil)
//        }
//    }
//}

//----------------------------------------
