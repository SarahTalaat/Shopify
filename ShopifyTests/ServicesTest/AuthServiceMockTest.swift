////
////  ServiceMockTest.swift
////  ShopifyTests
////
////  Created by Sara Talat on 24/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//import FirebaseAuth
//import FirebaseDatabase
//
//enum AuthErrorCode: Error {
//    case emailNotVerified
//    case networkError
//}
//
//import XCTest
//@testable import Shopify
//
//class FirebaseAuthServiceTests: XCTestCase {
//
//    var firebaseAuthService: FirebaseAuthService!
//    var mockDatabaseReference: MockDatabaseReference!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        mockDatabaseReference = MockDatabaseReference()
//        firebaseAuthService = FirebaseAuthService()
//    }
//
//    override func tearDownWithError() throws {
//        firebaseAuthService = nil
//        mockDatabaseReference = nil
//        try super.tearDownWithError()
//    }
//
//    // MARK: - Test Cases
////
////    func testSaveCustomerId_Success() {
////        // Arrange: Set up initial conditions
////        let name = "John Doe"
////        let email = "test@example.com"
////        let customerId = "customerId"
////        let favouriteId = "favId"
////        let shoppingCartId = "cartId"
////        let productId = "productId"
////        let productTitle = "Product"
////        let productVendor = "Vendor"
////        let productImage = "Image"
////        let isSignedIn = "true"
////
////        // Act: Call the method under test
////        firebaseAuthService.saveCustomerId(name: name, email: email, id: customerId, favouriteId: favouriteId, shoppingCartId: shoppingCartId, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage, isSignedIn: isSignedIn)
////
////        // Assert: Verify the result
////        // Verify that the customer data was correctly saved in the mock database reference
////        XCTAssertEqual(mockDatabaseReference.data["customers/test@example.com/customerId"], customerId)
////        XCTAssertEqual(mockDatabaseReference.data["customers/test@example.com/favouriteId"], favouriteId)
////        XCTAssertEqual(mockDatabaseReference.data["customers/test@example.com/shoppingCartId"], shoppingCartId)
////        XCTAssertEqual(mockDatabaseReference.data["products/productId/productTitle"], productTitle)
////        XCTAssertEqual(mockDatabaseReference.data["products/productId/productVendor"], productVendor)
////        XCTAssertEqual(mockDatabaseReference.data["products/productId/productImage"], productImage)
////        XCTAssertEqual(mockDatabaseReference.data["customers/test@example.com/isSignedIn"], isSignedIn)
////        // Adjust these keys and values based on how your mockDatabaseReference structures data.
////    }
//
//
//    func testAddProductToEncodedEmail_Success() {
//        // Arrange: Set up initial conditions
//        let email = "test_at_example,com"
//        let productId = "productId"
//        let productTitle = "Product"
//        let productVendor = "Vendor"
//        let productImage = "Image"
//
//        // Expected data structure
//        let expectedData: [String: Any] = [
//            "customers/\(email)/products/\(productId)/productTitle": productTitle,
//            "customers/\(email)/products/\(productId)/productVendor": productVendor,
//            "customers/\(email)/products/\(productId)/productImage": productImage
//        ]
//
//        // Act: Call the method under test
//        firebaseAuthService.addProductToEncodedEmail(email: email, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage)
//
//        // Assert: Verify the result
//        for (key, expectedValue) in expectedData {
//            if let value = value(forKeyPath: key, in: mockDatabaseReference.data) as? String {
//                XCTAssertEqual(value, expectedValue as? String, "Expected \(key) with value \(expectedValue) not found in mockDatabaseReference")
//            } else {
//                XCTFail("Expected \(key) with value \(expectedValue) not found in mockDatabaseReference")
//            }
//        }
//    }
//
//    // Helper function to get value from a nested dictionary using key path
//    func value(forKeyPath keyPath: String, in dictionary: [String: Any]) -> Any? {
//        var keys = keyPath.components(separatedBy: "/")
//        guard let firstKey = keys.first else { return nil }
//        keys.remove(at: 0)
//        
//        if keys.isEmpty {
//            return dictionary[firstKey]
//        } else if let subDict = dictionary[firstKey] as? [String: Any] {
//            return value(forKeyPath: keys.joined(separator: "/"), in: subDict)
//        } else {
//            return nil
//        }
//    }
//
//
//
//
//    func testFetchCustomerId_Success() {
//        firebaseAuthService.fetchCustomerId(encodedEmail: "encodedEmail") { customerId in
//            XCTAssertEqual(customerId, "testId")
//        }
//    }
//
//    func testDeleteProductFromEncodedEmail_Success() {
//        // Arrange: Set up initial conditions
//        let encodedEmail = "encodedEmail"
//        let productId = "productId"
//
//        // Act: Call the method under test
//        firebaseAuthService.deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: productId)
//
//        // Assert: Verify the result
//        // In the mock implementation, verify that the product was deleted from the correct path in the database
//        XCTAssertEqual(mockDatabaseReference.data.count, 0, "Expected database to have no entries after deletion")
//        // You might need to adjust this verification based on how your mockDatabaseReference stores and deletes data.
//    }
//
//
//    func testRetrieveAllProductsFromEncodedEmail_Success() {
//        firebaseAuthService.retrieveAllProductsFromEncodedEmail(email: "test@example.com") { products in
//            XCTAssertEqual(products.count, 1)
//            XCTAssertEqual(products[0].productId, "productId")
//        }
//    }
//
//    func testToggleFavorite_Success() {
//        firebaseAuthService.toggleFavorite(email: "test@example.com", productId: "productId", productTitle: "Product", productVendor: "Vendor", productImage: "Image", isFavorite: true) { error in
//            XCTAssertNil(error)
//        }
//    }
//
//    func testFetchFavorites_Success() {
//        firebaseAuthService.fetchFavorites(email: "test@example.com") { favorites in
//            XCTAssertEqual(favorites.count, 1)
//            XCTAssertTrue(favorites["productId"] ?? false)
//        }
//    }
//
//    func testCheckProductExists_True() {
//        firebaseAuthService.checkProductExists(email: "test@example.com", productId: "productId") { exists, error in
//            XCTAssertTrue(exists)
//            XCTAssertNil(error)
//        }
//    }
//
//    func testCheckProductExists_False() {
//        firebaseAuthService.checkProductExists(email: "test@example.com", productId: "nonExistentId") { exists, error in
//            XCTAssertFalse(exists)
//            XCTAssertNil(error)
//        }
//    }
//
//    func testCheckEmailSignInStatus_True() {
//        firebaseAuthService.checkEmailSignInStatus(email: "test@example.com") { isSignedIn in
//            XCTAssertTrue(isSignedIn ?? false)
//        }
//    }
//
//    func testCheckEmailSignInStatus_False() {
//        firebaseAuthService.checkEmailSignInStatus(email: "test@example.com") { isSignedIn in
//            XCTAssertFalse(isSignedIn ?? true)
//        }
//    }
//
//    func testUpdateSignInStatus_Success() {
//        firebaseAuthService.updateSignInStatus(email: "test@example.com", isSignedIn: "true") { success in
//            XCTAssertTrue(success)
//        }
//    }
//
//    func testFetchCustomerDataFromRealTimeDatabase_Success() {
//        firebaseAuthService.fetchCustomerDataFromRealTimeDatabase(forEmail: "test@example.com") { customerData in
//            XCTAssertNotNil(customerData)
//            XCTAssertEqual(customerData?.customerId, "customerId")
//            XCTAssertEqual(customerData?.name, "John Doe")
//            XCTAssertEqual(customerData?.email, "test@example.com")
//            XCTAssertEqual(customerData?.favouriteId, "favId")
//            XCTAssertEqual(customerData?.shoppingCartId, "cartId")
//        }
//    }
//
//    func testIsEmailTaken_True() {
//        firebaseAuthService.isEmailTaken(email: "test@example.com") { isTaken in
//            XCTAssertTrue(isTaken)
//        }
//    }
//
//    func testIsEmailTaken_False() {
//        firebaseAuthService.isEmailTaken(email: "nonexistent@example.com") { isTaken in
//            XCTAssertFalse(isTaken)
//        }
//    }
//
//    func testSetShoppingCartId_Success() {
//        firebaseAuthService.setShoppingCartId(email: "test@example.com", shoppingCartId: "cartId") { error in
//            XCTAssertNil(error)
//        }
//    }
//
//    func testGetShoppingCartId_Success() {
//        firebaseAuthService.getShoppingCartId(email: "test@example.com") { shoppingCartId, error in
//            XCTAssertNotNil(shoppingCartId)
//            XCTAssertEqual(shoppingCartId, "cartId")
//            XCTAssertNil(error)
//        }
//    }
//}
