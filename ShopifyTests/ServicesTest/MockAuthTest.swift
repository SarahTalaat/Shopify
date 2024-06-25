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

    func testFetchCustomerId() {
        let encodedEmail = "encodedEmail123"
        let customerId = "mockCustomerId"

        // Simulate setting up the customerId in mock database
        let customersRef = mockDatabaseRef.child("customers")
        let customerRef = customersRef.child(encodedEmail)
        customerRef.child("customerId").setValue(customerId)

        // Variable to store the fetched customerId
        var fetchedCustomerId: String?

        // Mock implementation of fetchCustomerId
        authService.fetchCustomerId(encodedEmail: encodedEmail) { result in
            fetchedCustomerId = result
        }

        // Assert the fetched customerId immediately after the completion block is executed
        XCTAssertEqual(fetchedCustomerId, customerId, "Fetched customerId should match")
    }

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

    func testRetrieveAllProductsFromEncodedEmail() {
        let mockDatabaseRef = MockDatabaseReference()
        let authService = FirebaseAuthService(databaseRef: mockDatabaseRef)
        
        let email = "test@example.com"
        let encodedEmail = SharedMethods.encodeEmail(email)
        
        // Simulate adding products
        let customersRef = mockDatabaseRef.child("customers")
        let customerRef = customersRef.child(encodedEmail)
        let productsRef = customerRef.child("products")
        
        let product1: [String: Any] = [
            "productId": "123",
            "productTitle": "Mock Product 1",
            "productVendor": "Mock Vendor 1",
            "productImage": "https://example.com/mock-product1.jpg"
        ]
        
        let product2: [String: Any] = [
            "productId": "456",
            "productTitle": "Mock Product 2",
            "productVendor": "Mock Vendor 2",
            "productImage": "https://example.com/mock-product2.jpg"
        ]
        
        productsRef.child("123").setValue(product1)
        productsRef.child("456").setValue(product2)
        
        // Test retrieving products
        authService.retrieveAllProductsFromEncodedEmail(email: email) { products in
            XCTAssertEqual(products.count, 2, "Should retrieve 2 products")
            
            XCTAssertEqual(products[0].productId, "123", "First product's productId should match")
            XCTAssertEqual(products[0].productTitle, "Mock Product 1", "First product's productTitle should match")
            XCTAssertEqual(products[0].productVendor, "Mock Vendor 1", "First product's productVendor should match")
            XCTAssertEqual(products[0].productImage, "https://example.com/mock-product1.jpg", "First product's productImage should match")
            
            XCTAssertEqual(products[1].productId, "456", "Second product's productId should match")
            XCTAssertEqual(products[1].productTitle, "Mock Product 2", "Second product's productTitle should match")
            XCTAssertEqual(products[1].productVendor, "Mock Vendor 2", "Second product's productVendor should match")
            XCTAssertEqual(products[1].productImage, "https://example.com/mock-product2.jpg", "Second product's productImage should match")
        }
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
