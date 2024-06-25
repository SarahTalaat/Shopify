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
    
   
}
