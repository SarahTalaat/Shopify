//
//  MockFirebaseTest.swift
//  ShopifyTests
//
//  Created by Sara Talat on 27/06/2024.
//


@testable import Shopify
import Foundation
import XCTest
import FirebaseAuth
import Firebase
import FirebaseDatabase


class MockFirebaseAuthServiceTests: XCTestCase {

    var mockFirebaseAuthService: MockFirebaseAuthService!

    override func setUp() {
        super.setUp()
        mockFirebaseAuthService = MockFirebaseAuthService()
    }

    func testSignInSuccess() {
        // Arrange
        let userModel = UserModel(uid: "id", email: "email")
        mockFirebaseAuthService.signInResult = .success(userModel)

        // Act
        var result: Result<UserModel, Error>?
        mockFirebaseAuthService.signIn(email: "email", password: "password") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success(let user):
                XCTAssertEqual(user.uid, "id")
                XCTAssertEqual(user.email, "email")
            case .failure(let error):
                XCTFail("Expected success result")
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }
    func testSignInFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.signInResult = .failure(error)

        // Act
        var result: Result<UserModel, Error>?
        mockFirebaseAuthService.signIn(email: "email", password: "password") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success(let user):
                XCTFail("Expected failure result")
            case .failure(let err):
                XCTAssertEqual(err as NSError, error)
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }
    func testSignOutSuccess() {
        // Arrange
        mockFirebaseAuthService.signOutResult = .success(())

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.signOut { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTAssert(true)
            case .failure(let error):
                XCTFail("Expected success result")
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testSignOutFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.signOutResult = .failure(error)

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.signOut { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTFail("Expected failure result")
            case .failure(let err):
                XCTAssertEqual(err as NSError, error)
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testSignUpSuccess() {
        // Arrange
        let userModel = UserModel(uid: "id", email: "email")
        mockFirebaseAuthService.signUpResult = .success(userModel)

        // Act
        var result: Result<UserModel, Error>?
        mockFirebaseAuthService.signUp(email: "email", password: "password") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success(let user):
                XCTAssertEqual(user.uid, "id")
                XCTAssertEqual(user.email, "email")
            case .failure(let error):
                XCTFail("Expected success result")
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testSignUpFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.signUpResult = .failure(error)

        // Act
        var result: Result<UserModel, Error>?
        mockFirebaseAuthService.signUp(email: "email", password: "password") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success(let user):
                XCTFail("Expected failure result")
            case .failure(let err):
                XCTAssertEqual(err as NSError, error)
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testCheckEmailVerificationSuccess() {
        // Arrange
        let auth = Auth.auth()
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.checkEmailVerificationResult = (true, nil)

        // Act
        var verificationResult: Bool?
        var verificationError: Error?
        auth.createUser(withEmail: "email@example.com", password: "password") { result, error in
            if let user = result?.user {
                mockFirebaseAuthService.checkEmailVerification(for: user) { verified, err in
                    verificationResult = verified
                    verificationError = err
                    // Assert
                    XCTAssertNotNil(verificationResult)
                    XCTAssertTrue(verificationResult!)
                    XCTAssertNil(verificationError)
                }
            } else {
                XCTFail("Failed to create user")
            }
        }
    }
    
    func testCheckEmailVerificationFailure() {
        // Arrange
        let auth = Auth.auth()
        let mockFirebaseAuthService = MockFirebaseAuthService()
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.checkEmailVerificationResult = (false, error)

        // Act
        var verificationResult: Bool?
        var verificationError: Error?
        auth.createUser(withEmail: "email@example.com", password: "password") { result, error in
            if let user = result?.user {
                mockFirebaseAuthService.checkEmailVerification(for: user) { verified, err in
                    verificationResult = verified
                    verificationError = err
                    // Assert
                    XCTAssertNotNil(verificationResult)
                    XCTAssertFalse(verificationResult!)
                    XCTAssertNotNil(verificationError)
                    if let verificationError = verificationError as? NSError, let error = error as? NSError {
                        XCTAssertEqual(verificationError.code, error.code)
                        XCTAssertEqual(verificationError.domain, error.domain)
                    } else {
                        XCTFail("Error types do not match")
                    }
                }
            } else {
                XCTFail("Failed to create user")
            }
        }
    }

    func testSaveCustomerIdSuccess() {
        // Arrange
        mockFirebaseAuthService.saveCustomerIdResult = .success(())

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.saveCustomerId(name: "name", email: "email", id: "id", favouriteId: "favouriteId", shoppingCartId: "shoppingCartId", productId: "productId", productTitle: "productTitle", productVendor: "productVendor", productImage: "productImage", isSignedIn: "isSignedIn") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTAssert(true)
            case .failure(let error):
                XCTFail("Expected success result")
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testSaveCustomerIdFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.saveCustomerIdResult = .failure(error)

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.saveCustomerId(name: "name", email: "email", id: "id", favouriteId: "favouriteId", shoppingCartId: "shoppingCartId", productId: "productId", productTitle: "productTitle", productVendor: "productVendor", productImage: "productImage", isSignedIn: "isSignedIn") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTFail("Expected failure result")
            case .failure(let err):
                XCTAssertEqual(err as NSError, error)
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testAddProductToEncodedEmailSuccess() {
        // Arrange
        mockFirebaseAuthService.addProductToEncodedEmailResult = .success(())

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.addProductToEncodedEmail(email: "email", productId: "productId", productTitle: "productTitle", productVendor: "productVendor", productImage: "productImage") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTAssert(true)
            case .failure(let error):
                XCTFail("Expected success result")
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testAddProductToEncodedEmailFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.addProductToEncodedEmailResult = .failure(error)

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.addProductToEncodedEmail(email: "email", productId: "productId", productTitle: "productTitle", productVendor: "productVendor", productImage: "productImage") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTFail("Expected failure result")
            case .failure(let err):
                XCTAssertEqual(err as NSError, error)
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testFetchCustomerIdSuccess() {
        // Arrange
        let customerId = "customerId"
        mockFirebaseAuthService.fetchCustomerIdResult = .success(customerId)

        // Act
        var result: String?
        mockFirebaseAuthService.fetchCustomerId(encodedEmail: "encodedEmail") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, customerId)
    }

    func testFetchCustomerIdFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.fetchCustomerIdResult = .failure(error)

        // Act
        var result: String?
        mockFirebaseAuthService.fetchCustomerId(encodedEmail: "encodedEmail") { result = $0 }

        // Assert
        XCTAssertNil(result)
    }

    func testDeleteProductFromEncodedEmailSuccess() {
        // Arrange
        mockFirebaseAuthService.deleteProductFromEncodedEmailResult = .success(())

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.deleteProductFromEncodedEmail(encodedEmail: "encodedEmail", productId: "productId") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTAssert(true)
            case .failure(let error):
                XCTFail("Expected success result")
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testDeleteProductFromEncodedEmailFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.deleteProductFromEncodedEmailResult = .failure(error)

        // Act
        var result: Result<Void, Error>?
        mockFirebaseAuthService.deleteProductFromEncodedEmail(encodedEmail: "encodedEmail", productId: "productId") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        if let result = result {
            switch result {
            case .success:
                XCTFail("Expected failure result")
            case .failure(let err):
                XCTAssertEqual(err as NSError, error)
            }
        } else {
            XCTFail("Expected a result, but got nil")
        }
    }

    func testRetrieveAllProductsFromEncodedEmailSuccess() {
        // Arrange
        let products = [ProductFromFirebase(productId: "id", productTitle: "Title", productVendor: "Vendor", productImage: "Image")]
        mockFirebaseAuthService.retrieveAllProductsFromEncodedEmailResult = .success(products)

        // Act
        var result: [ProductFromFirebase]?
        mockFirebaseAuthService.retrieveAllProductsFromEncodedEmail(email: "email") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, products)
    }

    func testRetrieveAllProductsFromEncodedEmailFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.retrieveAllProductsFromEncodedEmailResult = .failure(error)

        // Act
        var result: [ProductFromFirebase]?
        mockFirebaseAuthService.retrieveAllProductsFromEncodedEmail(email: "email") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [])
    }

    func testToggleFavoriteSuccess() {
        // Arrange
        mockFirebaseAuthService.toggleFavoriteResult = .success(())

        // Act
        var result: Error?
        mockFirebaseAuthService.toggleFavorite(email: "email", productId: "productId", productTitle: "productTitle", productVendor: "productVendor", productImage: "productImage", isFavorite: true) { result = $0 }

        // Assert
        XCTAssertNil(result)
    }

    func testToggleFavoriteFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.toggleFavoriteResult = .failure(error)

        // Act
        var result: Error?
        mockFirebaseAuthService.toggleFavorite(email: "email", productId: "productId", productTitle: "productTitle", productVendor: "productVendor", productImage: "productImage", isFavorite: true) { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertNotNil(result as? NSError)
        XCTAssertEqual((result as? NSError)?.domain, error.domain)
        XCTAssertEqual((result as? NSError)?.code, error.code)
    }

    func testFetchFavoritesSuccess() {
        // Arrange
        let favorites = [String: Bool]()
        mockFirebaseAuthService.fetchFavoritesResult = .success(favorites)

        // Act
        var result: [String: Bool]?
        mockFirebaseAuthService.fetchFavorites(email: "email") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, favorites)
    }

    func testFetchFavoritesFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.fetchFavoritesResult = .failure(error)

        // Act
        var result: [String: Bool]?
        mockFirebaseAuthService.fetchFavorites(email: "email") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, [:])
    }

    func testCheckProductExistsSuccess() {
        // Arrange
        let expectedResult: (Bool, Error?) = (true, nil)
        mockFirebaseAuthService.checkProductExistsResult = expectedResult

        // Act
        var result: (Bool, Error?)?
        mockFirebaseAuthService.checkProductExists(email: "email", productId: "productId") { exists, error in
            result = (exists, error)
        }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.0 == true)
        XCTAssertNil(result?.1)
    }

    func testCheckProductExistsFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.checkProductExistsResult = (false, error)

        // Act
        var result: (Bool, Error?)?
        mockFirebaseAuthService.checkProductExists(email: "email", productId: "productId") { exists, error in
            result = (exists, error)
        }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, false)
        XCTAssertNotNil(result?.1)
        XCTAssertEqual((result?.1 as NSError?)?.domain, error.domain)
        XCTAssertEqual((result?.1 as NSError?)?.code, error.code)
    }

    func testCheckEmailSignInStatusSuccess() {
        // Arrange
        mockFirebaseAuthService.checkEmailSignInStatusResult = (true, nil)

        // Act
        var result: Bool?
        mockFirebaseAuthService.checkEmailSignInStatus(email: "email") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, true)
    }

    func testCheckEmailSignInStatusFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.checkEmailSignInStatusResult = (false, error)

        // Act
        var result: Bool?
        mockFirebaseAuthService.checkEmailSignInStatus(email: "email") { result = $0 }

        // Assert
        XCTAssertEqual(result, false)
    }

    func testUpdateSignInStatusSuccess() {
        // Arrange
        mockFirebaseAuthService.updateSignInStatusResult = .success(())

        // Act
        var result: Bool?
        mockFirebaseAuthService.updateSignInStatus(email: "email", isSignedIn: "isSignedIn") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, true)
    }

    func testUpdateSignInStatusFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.updateSignInStatusResult = .failure(error)

        // Act
        var result: Bool?
        mockFirebaseAuthService.updateSignInStatus(email: "email", isSignedIn: "isSignedIn") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, false)
    }

    func testFetchCustomerDataFromRealTimeDatabaseSuccess() {
        // Arrange
        let customerData = CustomerData(customerId: "customerId", name: "John Doe", email: "john@example.com", favouriteId: "favouriteId", shoppingCartId: "shoppingCartId")
        mockFirebaseAuthService.fetchCustomerDataFromRealTimeDatabaseResult = .success(customerData)

        // Act
        var result: CustomerData?
        mockFirebaseAuthService.fetchCustomerDataFromRealTimeDatabase(forEmail: "john@example.com") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, customerData)
    }
    func testFetchCustomerDataFromRealTimeDatabaseFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.fetchCustomerDataFromRealTimeDatabaseResult = .failure(error)

        // Act
        var result: CustomerData?
        mockFirebaseAuthService.fetchCustomerDataFromRealTimeDatabase(forEmail: "email") { result = $0 }

        // Assert
        XCTAssertNil(result)
    }

    func testIsEmailTakenSuccess() {
        // Arrange
        mockFirebaseAuthService.isEmailTakenResult = .success(true)

        // Act
        var result: Bool?
        mockFirebaseAuthService.isEmailTaken(email: "email") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, true)
    }

    func testIsEmailTakenFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.isEmailTakenResult = .failure(error)

        // Act
        var result: Bool?
        mockFirebaseAuthService.isEmailTaken(email: "email") { result = $0 }

        // Assert
        XCTAssertEqual(result, false)
    }

    func testSetShoppingCartIdSuccess() {
        // Arrange
        mockFirebaseAuthService.setShoppingCartIdResult = .success(())

        // Act
        var result: Error?
        mockFirebaseAuthService.setShoppingCartId(email: "email", shoppingCartId: "shoppingCartId") { result = $0 }

        // Assert
        XCTAssertNil(result)
    }

    func testSetShoppingCartIdFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.setShoppingCartIdResult = .failure(error)

        // Act
        var result: Error?
        mockFirebaseAuthService.setShoppingCartId(email: "email", shoppingCartId: "shoppingCartId") { result = $0 }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.localizedDescription, error.localizedDescription)
    }

    func testGetShoppingCartIdSuccess() {
        // Arrange
        let shoppingCartId = "shoppingCartId"
        mockFirebaseAuthService.getShoppingCartIdResult = .success(shoppingCartId)

        // Act
        var result: String?
        var error: Error?
        mockFirebaseAuthService.getShoppingCartId(email: "email") { id, err in
            result = id
            error = err
        }

        // Assert
        XCTAssertNotNil(result)
        XCTAssertNil(error)
        XCTAssertEqual(result, shoppingCartId)
    }

    func testGetShoppingCartIdFailure() {
        // Arrange
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        mockFirebaseAuthService.getShoppingCartIdResult = .failure(error)

        // Act
        var result: String?
        var errorResult: Error?
        mockFirebaseAuthService.getShoppingCartId(email: "email") { id, err in
            result = id
            errorResult = err
        }

        // Assert
        XCTAssertNil(result)
        XCTAssertNotNil(errorResult)
    }
}
