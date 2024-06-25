//
//  MockAuthTest.swift
//  ShopifyTests
//
//  Created by Sara Talat on 25/06/2024.
//

import Foundation
import XCTest
@testable import Shopify
import FirebaseDatabase
import FirebaseAuth
import Firebase

class FirebaseAuthServiceTests: XCTestCase {

    var authService: FirebaseAuthService!
    var mockDatabaseRef: MockDatabaseReference!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Initialize the mock database reference
        mockDatabaseRef = MockDatabaseReference()
        // Inject the mock database reference into FirebaseAuthService
        authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
    }

    override func tearDownWithError() throws {
        // Clean up after each test if needed
        authService = nil
        mockDatabaseRef = nil
        try super.tearDownWithError()
    }
    
    func testSaveCustomerId() {
        // Given
        let name = "John Doe"
        let email = "john.doe@example.com"
        let id = "12345"
        let favouriteId = "67890"
        let shoppingCartId = "54321"
        let productId = "abcde"
        let productTitle = "Test Product"
        let productVendor = "Test Vendor"
        let productImage = "https://example.com/image.jpg"
        let isSignedIn = "true"
        
        // When
        authService.saveCustomerId(
            name: name,
            email: email,
            id: id,
            favouriteId: favouriteId,
            shoppingCartId: shoppingCartId,
            productId: productId,
            productTitle: productTitle,
            productVendor: productVendor,
            productImage: productImage,
            isSignedIn: isSignedIn
        )
        
        // Then
        let expectedEncodedEmail = SharedMethods.encodeEmail(email)
        let customersRef = mockDatabaseRef.child("customers")
        let customerRef = customersRef.child(expectedEncodedEmail)
        
        print("Expected customer reference path url: \(customerRef.url)")
        print("Expected customer reference path root: \(customerRef.root)")
        print("Expected customer reference path db: \(customerRef.database)")
        
        customerRef.observeSingleEvent(of: .value) { snapshot in
            XCTAssert(snapshot.exists(), "Customer data should exist")
            
            if let customerData = snapshot.value as? [String: Any] {
                print("Customer data retrieved from Firebase:")
                print(customerData)
                
                XCTAssertEqual(customerData["customerId"] as? String, id, "customerId should match")
                XCTAssertEqual(customerData["email"] as? String, email, "email should match")
                XCTAssertEqual(customerData["name"] as? String, name, "name should match")
                XCTAssertEqual(customerData["isSignedIn"] as? String, isSignedIn, "isSignedIn should match")
                XCTAssertEqual(customerData["favouriteId"] as? String, favouriteId, "favouriteId should match")
                XCTAssertEqual(customerData["shoppingCartId"] as? String, shoppingCartId, "shoppingCartId should match")
                
                if let products = customerData["products"] as? [String: [String: Any]] {
                    print("Products retrieved from Firebase:")
                    print(products)
                    
                    XCTAssertNotNil(products[productId], "Product with productId should exist")
                    XCTAssertEqual(products[productId]?["productTitle"] as? String, productTitle, "productTitle should match")
                    XCTAssertEqual(products[productId]?["productVendor"] as? String, productVendor, "productVendor should match")
                    XCTAssertEqual(products[productId]?["productImage"] as? String, productImage, "productImage should match")
                } else {
                    XCTFail("Products data format is incorrect or missing")
                }
            } else {
                XCTFail("Customer data format is incorrect or missing")
            }
        }
    }
    func testAddProductToEncodedEmail() {
        let mockDatabaseRef = MockDatabaseReference()
        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
        
        let email = "test@example.com"
        let productId = "123"
        let productTitle = "Mock Product"
        let productVendor = "Mock Vendor"
        let productImage = "https://example.com/mock-product.jpg"
        
        authService.addProductToEncodedEmail(
            email: email,
            productId: productId,
            productTitle: productTitle,
            productVendor: productVendor,
            productImage: productImage
        )
        
        // Verify if product was added correctly
        let expectedEncodedEmail = SharedMethods.encodeEmail(email)
        let customersRef = mockDatabaseRef.child("customers")
        let customerRef = customersRef.child(expectedEncodedEmail)
        let productsRef = customerRef.child("products").child(productId)
        
        productsRef.observeSingleEvent(of: .value) { snapshot in
            XCTAssertTrue(snapshot.exists(), "Product should exist in database")
            
            if let productData = snapshot.value as? [String: Any] {
                XCTAssertEqual(productData["productId"] as? String, productId, "productId should match")
                XCTAssertEqual(productData["productTitle"] as? String, productTitle, "productTitle should match")
                XCTAssertEqual(productData["productVendor"] as? String, productVendor, "productVendor should match")
                XCTAssertEqual(productData["productImage"] as? String, productImage, "productImage should match")
            } else {
                XCTFail("Product data format is incorrect or missing")
            }
        }
    }

//    func testFetchCustomerId() {
//        let encodedEmail = "encodedEmail123"
//        let customerId = "mockCustomerId"
//
//        // Simulate setting up the customerId in mock database
//        let customersRef = mockDatabaseRef.child("customers")
//        let customerRef = customersRef.child(encodedEmail)
//        customerRef.child("customerId").setValue(customerId)
//
//        // Variable to store the fetched customerId
//        var fetchedCustomerId: String?
//
//        // Mock implementation of fetchCustomerId
//        authService.fetchCustomerId(encodedEmail: encodedEmail) { result in
//            fetchedCustomerId = result
//        }
//
//        // Assert the fetched customerId immediately after the completion block is executed
//        XCTAssertEqual(fetchedCustomerId, customerId, "Fetched customerId should match")
//    }

    func testDeleteProductFromEncodedEmail() {
        let mockDatabaseRef = MockDatabaseReference()
        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
        
        let encodedEmail = "test@example.com"
        let productId = "123"
        
        // Simulate adding product first
        let customersRef = mockDatabaseRef.child("customers")
        let customerRef = customersRef.child(encodedEmail)
        let productsRef = customerRef.child("products").child(productId)
        
        let productData: [String: Any] = [
            "productId": productId,
            "productTitle": "Mock Product",
            "productVendor": "Mock Vendor",
            "productImage": "https://example.com/mock-product.jpg"
        ]
        
        productsRef.setValue(productData)
        
        // Now, delete the product
        authService.deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: productId)
        
        // Verify if product was deleted
        productsRef.observeSingleEvent(of: .value) { snapshot in
            XCTAssertFalse(snapshot.exists(), "Product should no longer exist in database after deletion")
        }
    }
//
//    func testRetrieveAllProductsFromEncodedEmail() {
//        // Given
//        let mockDatabaseRef = MockDatabaseReference()
//        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
//
//        let email = "test@example.com"
//        let encodedEmail = SharedMethods.encodeEmail(email)
//
//        // Simulate adding products to the mock database
//        let customersRef = mockDatabaseRef.child("customers")
//        let customerRef = customersRef.child(encodedEmail)
//        let productsRef = customerRef.child("products")
//
//        let product1: [String: Any] = [
//            "productId": "123",
//            "productTitle": "Mock Product 1",
//            "productVendor": "Mock Vendor 1",
//            "productImage": "https://example.com/mock-product1.jpg"
//        ]
//
//        let product2: [String: Any] = [
//            "productId": "456",
//            "productTitle": "Mock Product 2",
//            "productVendor": "Mock Vendor 2",
//            "productImage": "https://example.com/mock-product2.jpg"
//        ]
//
//        // Set up products in mock database
//        productsRef.child("123").setValue(product1)
//        productsRef.child("456").setValue(product2)
//
//        // When
//        var retrievedProducts: [ProductFromFirebase]?
//        authService.retrieveAllProductsFromEncodedEmail(email: email) { products in
//            retrievedProducts = products
//            print("xxx retrieved products \(retrievedProducts)")
//            print("xxx products \(products)")
//        }
//
//        // Then
//        XCTAssertNotNil(retrievedProducts, "Products should not be nil")
//        XCTAssertEqual(retrievedProducts?.count, 2, "Should retrieve 2 products")
//
//        print("xxx retrievedProducts count \(retrievedProducts?.count)")
//
//        if let products = retrievedProducts {
//            // Assert details of the first product
//            XCTAssertEqual(products[0].productId, "123", "First product's productId should match")
//            XCTAssertEqual(products[0].productTitle, "Mock Product 1", "First product's productTitle should match")
//            XCTAssertEqual(products[0].productVendor, "Mock Vendor 1", "First product's productVendor should match")
//            XCTAssertEqual(products[0].productImage, "https://example.com/mock-product1.jpg", "First product's productImage should match")
//
//            // Assert details of the second product
//            XCTAssertEqual(products[1].productId, "456", "Second product's productId should match")
//            XCTAssertEqual(products[1].productTitle, "Mock Product 2", "Second product's productTitle should match")
//            XCTAssertEqual(products[1].productVendor, "Mock Vendor 2", "Second product's productVendor should match")
//            XCTAssertEqual(products[1].productImage, "https://example.com/mock-product2.jpg", "Second product's productImage should match")
//        }
//    }


    func testToggleFavorite() {
        // Given
        let mockDatabaseRef = MockDatabaseReference()
        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
        
        let email = "test@example.com"
        let encodedEmail = SharedMethods.encodeEmail(email)
        let productId = "123"
        let productTitle = "Mock Product"
        let productVendor = "Mock Vendor"
        let productImage = "https://example.com/mock-product.jpg"
        let isFavorite = true
        
        // When toggling favorite
        authService.toggleFavorite(
            email: email,
            productId: productId,
            productTitle: productTitle,
            productVendor: productVendor,
            productImage: productImage,
            isFavorite: isFavorite
        ) { error in
            XCTAssertNil(error, "Error should be nil when adding to favorites")
            
            // Then
            let productRef = mockDatabaseRef.child("customers").child(encodedEmail).child("products").child(productId)
            productRef.observeSingleEvent(of: .value) { snapshot in
                XCTAssertTrue(snapshot.exists(), "Product should be added to favorites")
                
                if let productData = snapshot.value as? [String: Any] {
                    XCTAssertEqual(productData["productId"] as? String, productId, "productId should match")
                    XCTAssertEqual(productData["productTitle"] as? String, productTitle, "productTitle should match")
                    XCTAssertEqual(productData["productVendor"] as? String, productVendor, "productVendor should match")
                    XCTAssertEqual(productData["productImage"] as? String, productImage, "productImage should match")
                } else {
                    XCTFail("Product data format is incorrect or missing")
                }
            }
        }
    }

    func testRemoveFavorite() {
        // Given
        let mockDatabaseRef = MockDatabaseReference()
        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
        
        let email = "test@example.com"
        let encodedEmail = SharedMethods.encodeEmail(email)
        let productId = "123"
        
        // Simulate adding product first
        let productRef = mockDatabaseRef.child("customers").child(encodedEmail).child("products").child(productId)
        let productData: [String: Any] = [
            "productId": productId,
            "productTitle": "Mock Product",
            "productVendor": "Mock Vendor",
            "productImage": "https://example.com/mock-product.jpg"
        ]
        productRef.setValue(productData)
        
        // When toggling favorite to remove
        authService.toggleFavorite(
            email: email,
            productId: productId,
            productTitle: "Mock Product",
            productVendor: "Mock Vendor",
            productImage: "https://example.com/mock-product.jpg",
            isFavorite: false
        ) { error in
            XCTAssertNil(error, "Error should be nil when removing from favorites")
            
            // Then
            productRef.observeSingleEvent(of: .value) { snapshot in
                XCTAssertFalse(snapshot.exists(), "Product should be removed from favorites")
            }
        }
    }
    
//    func testFetchFavorites() {
//        // Given
//        let mockDatabaseRef = MockDatabaseReference()
//        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
//
//        let email = "test@example.com"
//        let encodedEmail = SharedMethods.encodeEmail(email)
//
//        // Simulate setting favorites in mock database
//        let customersRef = mockDatabaseRef.child("customers")
//        let customerRef = customersRef.child(encodedEmail)
//        let productsRef = customerRef.child("products")
//
//        let product1: [String: Any] = [
//            "productId": "123",
//            "productTitle": "Mock Product 1",
//            "productVendor": "Mock Vendor 1",
//            "productImage": "https://example.com/mock-product1.jpg"
//        ]
//        let product2: [String: Any] = [
//            "productId": "456",
//            "productTitle": "Mock Product 2",
//            "productVendor": "Mock Vendor 2",
//            "productImage": "https://example.com/mock-product2.jpg"
//        ]
//        productsRef.child("123").setValue(product1)
//        productsRef.child("456").setValue(product2)
//
//        // When fetching favorites
//        var fetchedFavorites: [String: Bool]?
//        authService.fetchFavorites(email: email) { favorites in
//            fetchedFavorites = favorites
//        }
//
//        // Then
//        XCTAssertNotNil(fetchedFavorites, "Favorites should not be nil")
//        XCTAssertEqual(fetchedFavorites?.count, 2, "Should retrieve 2 favorites")
//
//        if let favorites = fetchedFavorites {
//            XCTAssertTrue(favorites.keys.contains("123"), "Product 123 should be in favorites")
//            XCTAssertTrue(favorites.keys.contains("456"), "Product 456 should be in favorites")
//        }
//    }

//    func testCheckProductExists() {
//        // Given
//        let mockDatabaseRef = MockDatabaseReference()
//        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
//
//        let email = "test@example.com"
//        let encodedEmail = SharedMethods.encodeEmail(email)
//        let productId = "123"
//
//        // Simulate adding product to mock database
//        let productsRef = mockDatabaseRef.child("customers").child(encodedEmail).child("products").child(productId)
//        let productData: [String: Any] = [
//            "productId": productId,
//            "productTitle": "Mock Product",
//            "productVendor": "Mock Vendor",
//            "productImage": "https://example.com/mock-product.jpg"
//        ]
//        productsRef.setValue(productData)
//
//        // When checking if product exists
//        var productExists: Bool?
//        var productError: Error?
//        authService.checkProductExists(email: email, productId: productId) { exists, error in
//            productExists = exists
//            productError = error
//        }
//
//        // Then
//        XCTAssertNil(productError, "Error should be nil when product exists")
//        XCTAssertTrue(productExists ?? false, "Product should exist")
//    }
//
//    func testCheckProductDoesNotExist() {
//        // Given
//        let mockDatabaseRef = MockDatabaseReference()
//        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
//
//        let email = "test@example.com"
//        let encodedEmail = SharedMethods.encodeEmail(email)
//        let productId = "999"
//
//        // When checking if product exists
//        var productExists: Bool?
//        var productError: Error?
//        authService.checkProductExists(email: email, productId: productId) { exists, error in
//            productExists = exists
//            productError = error
//        }
//
//        // Then
//        XCTAssertNil(productError, "Error should be nil when product does not exist")
//        XCTAssertFalse(productExists ?? true, "Product should not exist")
//    }

//    func testCheckEmailSignInStatusSignedIn() {
//        // Given
//        let mockDatabaseRef = MockDatabaseReference()
//        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
//        
//        let email = "test@example.com"
//        let encodedEmail = SharedMethods.encodeEmail(email)
//        
//        // Simulate setting sign-in status to "true" in mock database
//        let customerRef = mockDatabaseRef.child("customers").child(encodedEmail)
//        let customerData: [String: Any] = [
//            "isSignedIn": "true"
//        ]
//        customerRef.setValue(customerData)
//        
//        // When checking sign-in status
//        var isSignedIn: Bool?
//        authService.checkEmailSignInStatus(email: email) { status in
//            isSignedIn = status
//        }
//        
//        // Then
//        XCTAssertNotNil(isSignedIn, "Sign-in status should not be nil")
//        XCTAssertTrue(isSignedIn ?? false, "User should be signed in")
//    }

//    func testCheckEmailSignInStatusNotSignedIn() {
//        // Given
//        let mockDatabaseRef = MockDatabaseReference()
//        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
//
//        let email = "test@example.com"
//        let encodedEmail = SharedMethods.encodeEmail(email)
//
//        // Simulate setting sign-in status to "false" in mock database
//        let customerRef = mockDatabaseRef.child("customers").child(encodedEmail)
//        let customerData: [String: Any] = [
//            "isSignedIn": "false"
//        ]
//        customerRef.setValue(customerData)
//
//        // When checking sign-in status
//        var isSignedIn: Bool?
//        authService.checkEmailSignInStatus(email: email) { status in
//            isSignedIn = status
//        }
//
//        // Then
//        XCTAssertNotNil(isSignedIn, "Sign-in status should not be nil")
//        XCTAssertFalse(isSignedIn ?? true, "User should not be signed in")
//    }

    func testCheckEmailSignInStatusNotSet() {
        // Given
        let mockDatabaseRef = MockDatabaseReference()
        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
        
        let email = "test@example.com"
        let encodedEmail = SharedMethods.encodeEmail(email)
        
        // Simulate no sign-in status set in mock database
        let customerRef = mockDatabaseRef.child("customers").child(encodedEmail)
        customerRef.removeValue()
        
        // When checking sign-in status
        var isSignedIn: Bool?
        authService.checkEmailSignInStatus(email: email) { status in
            isSignedIn = status
        }
        
        // Then
        XCTAssertNil(isSignedIn, "Sign-in status should be nil when not set")
    }

    
}

// Mock DatabaseReference implementation for testing purposes
class MockDatabaseReference: DatabaseReference {
    
    private var childRefs: [String: MockDatabaseReference]
    private var value: Any?
    
    override init() {
        childRefs = [:]
        value = nil
    }
    
    override func child(_ path: String) -> DatabaseReference {
        if let existingRef = childRefs[path] {
            return existingRef
        } else {
            let newRef = MockDatabaseReference()
            childRefs[path] = newRef
            return newRef
        }
    }
    
    override func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
        self.value = value
        block(nil, self)
    }
    
    override func removeValue(completionBlock: @escaping (Error?, DatabaseReference) -> Void) {
        self.value = nil
        completionBlock(nil, self)
    }
    
    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
        let snapshot = MockDataSnapshot(value: value)
        block(snapshot)
    }
    
    // Add more methods as needed for mocking Firebase operations
}


// Mock DataSnapshot implementation for testing purposes
class MockDataSnapshot: DataSnapshot {
    
    private let mockValue: Any?
    
    init(value: Any?) {
        self.mockValue = value
    }
    
    override func exists() -> Bool {
        return mockValue != nil
    }
    
    override var value: Any? {
        return mockValue
    }
    
    override func childSnapshot(forPath path: String) -> DataSnapshot {
        if let valueDict = mockValue as? [String: Any], let childValue = valueDict[path] {
            return MockDataSnapshot(value: childValue)
        } else {
            return MockDataSnapshot(value: nil)
        }
    }
    
    // Add more methods as needed
}
