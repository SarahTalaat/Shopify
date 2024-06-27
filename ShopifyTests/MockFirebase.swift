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


class MockFirebaseAuthService3: FirebaseAuthService {

    var signInResult: Result<UserModel, Error>?
    var updateSignInStatusResult: Result<Void, Error>?
    
    var checkEmailSignInStatusResult: Bool?
    var postDraftOrderResult: Result<OneDraftOrderResponse, Error>?
    var fetchCustomerDataResult: CustomerData?
    var getShoppingCartIdResult: String?

    
    var capturedShoppingCartId: String?
    var capturedEmail: String?
    var setShoppingCartIdCompletion: ((Error?) -> Void)?
    

    override func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
        if let updateSignInStatusResult = updateSignInStatusResult {
            switch updateSignInStatusResult {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        } else {
            completion(false)
        }
    }

    override func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
        completion(checkEmailSignInStatusResult)
    }

    override func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
        completion(fetchCustomerDataResult)
    }
    
    override func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
        capturedEmail = email
        capturedShoppingCartId = shoppingCartId
        setShoppingCartIdCompletion = completion
        completion(nil)
    }

    override func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
        completion(nil, nil)
    }
    override func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if let signInResult = signInResult {
            completion(signInResult)
        } else {
            // Simulate default behavior or handle as needed
            completion(.failure(NSError(domain: "MockAuthService", code: 500, userInfo: nil)))
        }
    }


    // Add more overrides for other FirebaseAuthService methods used in SignInViewModel
}

// Mock NetworkServiceAuthentication for testing

import XCTest

class MockFirebaseAuthService3Tests: XCTestCase {

    var authService: MockFirebaseAuthService3!

    override func setUp() {
        super.setUp()
        authService = MockFirebaseAuthService3(forTesting: true)
    }

    func testUpdateSignInStatusSuccess() {
        authService.updateSignInStatusResult = .success(())
        var result: Bool?
        authService.updateSignInStatus(email: "shopifyapp.test7@gmail.com", isSignedIn: "true") { result = $0 }
        XCTAssertEqual(result, true)
    }

    func testUpdateSignInStatusFailure() {
        authService.updateSignInStatusResult = .failure(NSError(domain: "MockAuthService", code: 500, userInfo: nil))
        var result: Bool?
        authService.updateSignInStatus(email: "shopifyapp.test7@gmail.com", isSignedIn: "true") { result = $0 }
        XCTAssertEqual(result, false)
    }

    func testCheckEmailSignInStatus() {
        authService.checkEmailSignInStatusResult = true
        var result: Bool?
        authService.checkEmailSignInStatus(email: "shopifyapp.test7@gmail.com") { result = $0 }
        XCTAssertEqual(result, true)
    }

    func testFetchCustomerDataFromRealTimeDatabase() {
        let customerData = CustomerData(customerId: "7533489127585", name: "Sarah", email: "shopifyapp.test7@gmail.com", favouriteId: "", shoppingCartId: "1036337250465")
        authService.fetchCustomerDataResult = customerData
        var result: CustomerData?
        authService.fetchCustomerDataFromRealTimeDatabase(forEmail: "shopifyapp.test7@gmail.com") { result = $0 }
        XCTAssertEqual(result, customerData)
    }

    func testSetShoppingCartId() {
        var error: Error?
        authService.setShoppingCartId(email: "shopifyapp.test7@gmail.com", shoppingCartId: "1036337250465") { error = $0 }
        XCTAssertNil(error)
        XCTAssertEqual(authService.capturedEmail, "shopifyapp.test7@gmail.com")
        XCTAssertEqual(authService.capturedShoppingCartId, "1036337250465")
    }

    func testGetShoppingCartId() {
        authService.getShoppingCartId(email: "shopifyapp.test7@gmail.com") { result, error in
            XCTAssertNil(result)
            XCTAssertNil(error)
        }
    }

    func testSignInSuccess() {
        let userModel = UserModel(uid: "JfFRqCqJbaSSgNn9Nnm8xumPM1l1", email: "shopifyapp.test7@gmail.com")
        authService.signInResult = .success(userModel)
        var result: Result<UserModel, Error>?
        authService.signIn(email: "shopifyapp.test7@gmail.com", password: "password") { result = $0 }
        if case.success(let user) = result {
            XCTAssertEqual(user.email, userModel.email)
            XCTAssertEqual(user.uid, userModel.uid)
        } else {
            XCTFail("Expected success result, but got failure")
        }
    }

    func testSignInFailure() {
        authService.signInResult = .failure(NSError(domain: "MockAuthService", code: 500, userInfo: nil))
        var result: Result<UserModel, Error>?
        authService.signIn(email: "shopifyapp.test7@gmail.com", password: "password") { result = $0 }
        if case.failure(let error) = result {
            XCTAssertNotNil(error)
        } else {
            XCTFail("Expected failure result, but got success")
        }
    }
}
