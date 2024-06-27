//
//  MockFirebase.swift
//  ShopifyTests
//
//  Created by Sara Talat on 27/06/2024.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase
@testable import Shopify

class MockFirebaseAuthService {
    

    var signInResult: Result<UserModel, Error>?
    var signOutResult: Result<Void, Error>?
    var signUpResult: Result<UserModel, Error>?
    var checkEmailVerificationResult: (Bool, Error?)?
    var saveCustomerIdResult: Result<Void, Error>?
    var addProductToEncodedEmailResult: Result<Void, Error>?
    var fetchCustomerIdResult: Result<String?, Error>?
    var deleteProductFromEncodedEmailResult: Result<Void, Error>?
    var retrieveAllProductsFromEncodedEmailResult: Result<[ProductFromFirebase], Error>?
    var toggleFavoriteResult: Result<Void, Error>?
    var fetchFavoritesResult: Result<[String: Bool], Error>?
    var checkProductExistsResult: (Bool, Error?)?
    var checkEmailSignInStatusResult: (Bool?, Error?)?
    var updateSignInStatusResult: Result<Void, Error>?
    var fetchCustomerDataFromRealTimeDatabaseResult: Result<CustomerData?, Error>?
    var isEmailTakenResult: Result<Bool, Error>?
    var setShoppingCartIdResult: Result<Void, Error>?
    var getShoppingCartIdResult: Result<String?, Error>?
    var fetchCustomerDataFromRealTimeDatabaseCompletionHandler: ((String) -> CustomerData?)?



    
     func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if let signInResult = signInResult {
            completion(signInResult)
        }
    }
        
     func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        if let signOutResult = signOutResult {
            completion(signOutResult)
        }
    }

     func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if let signUpResult = signUpResult {
            completion(signUpResult)
        }
    }

     func checkEmailVerification(for user: User, completion: @escaping (Bool, Error?) -> Void) {
        if let result = checkEmailVerificationResult {
            completion(result.0, result.1)
        }
    }

    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String, isSignedIn: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let saveCustomerIdResult = saveCustomerIdResult {
            completion(saveCustomerIdResult)
        }
    }

    func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let addProductToEncodedEmailResult = addProductToEncodedEmailResult {
            completion(addProductToEncodedEmailResult)
        }
    }

     func fetchCustomerId(encodedEmail: String, completion: @escaping (String?) -> Void) {
        if let fetchCustomerIdResult = fetchCustomerIdResult {
            switch fetchCustomerIdResult {
            case.success(let value):
                completion(value)
            case.failure(let error):
                completion(nil)
                // You can also handle the error here if needed
            }
        }
    }

    func deleteProductFromEncodedEmail(encodedEmail: String, productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let deleteProductFromEncodedEmailResult = deleteProductFromEncodedEmailResult {
            completion(deleteProductFromEncodedEmailResult)
        }
    }

     func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void) {
        if let retrieveAllProductsFromEncodedEmailResult = retrieveAllProductsFromEncodedEmailResult {
            switch retrieveAllProductsFromEncodedEmailResult {
            case .success(let value):
                completion(value)
            case .failure(let error):
                completion([])
                // You can also handle the error here if needed
            }
        }
    }

     func toggleFavorite(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
        if let toggleFavoriteResult = toggleFavoriteResult {
            switch toggleFavoriteResult {
            case.success:
                completion(nil)
            case.failure(let error):
                completion(error)
            }
        }
    }

     func fetchFavorites(email: String, completion: @escaping ([String: Bool]) -> Void) {
        if let fetchFavoritesResult = fetchFavoritesResult {
            switch fetchFavoritesResult {
            case.success(let value):
                completion(value)
            case.failure(let error):
                completion([:])
                // You can also handle the error here if needed
            }
        }
    }

     func checkProductExists(email: String, productId: String, completion: @escaping (Bool, Error?) -> Void) {
        if let checkProductExistsResult = checkProductExistsResult {
            completion(checkProductExistsResult.0, checkProductExistsResult.1)
        }
    }

     func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
        if let checkEmailSignInStatusResult = checkEmailSignInStatusResult {
            completion(checkEmailSignInStatusResult.0)
        }
    }

     func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
        if let updateSignInStatusResult = updateSignInStatusResult {
            switch updateSignInStatusResult {
            case.success:
                completion(true)
            case.failure(let error):
                completion(false)
                // You can also handle the error here if needed
            }
        }
    }

     func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
            if let handler = fetchCustomerDataFromRealTimeDatabaseCompletionHandler {
                completion(handler(email))
            } else if let fetchCustomerDataFromRealTimeDatabaseResult = fetchCustomerDataFromRealTimeDatabaseResult {
                switch fetchCustomerDataFromRealTimeDatabaseResult {
                case .success(let value):
                    completion(value)
                case .failure(let error):
                    completion(nil)
                    // You can also handle the error here if needed
                }
            }
        }

     func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
        if let isEmailTakenResult = isEmailTakenResult {
            switch isEmailTakenResult {
            case.success(let value):
                completion(value)
            case.failure(let error):
                completion(false)
                // You can also handle the error here if needed
            }
        }
    }

     func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
        if let setShoppingCartIdResult = setShoppingCartIdResult {
            switch setShoppingCartIdResult {
            case.success:
                completion(nil)
            case.failure(let error):
                completion(error)
            }
        }
    }

     func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
        if let getShoppingCartIdResult = getShoppingCartIdResult {
            switch getShoppingCartIdResult {
            case.success(let value):
                completion(value, nil)
            case.failure(let error):
                completion(nil, error)
            }
        }
    }
}
