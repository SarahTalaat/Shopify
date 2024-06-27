//
//  MockAuthTest.swift
//  ShopifyTests
//
//  Created by Sara Talat on 25/06/2024.
//

import Foundation

import XCTest
@testable import Shopify

class MockAuthServiceTests: XCTestCase {
    
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
    }
    
    override func tearDown() {
        mockAuthService = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testSignIn() {
        // Given
        let email = "test@example.com"
        let password = "password"
        
        // When
        mockAuthService.signIn(email: email, password: password) { result in
            // Then (For synchronous testing, handle result directly here)
            switch result {
            case .success(let user):
                XCTAssertEqual(user.uid, "mocked_uid")
                XCTAssertEqual(user.email, email)
                XCTAssertNotNil(self.mockAuthService.currentUserUID)
            case .failure(let error):
                XCTFail("Sign in failed with error: \(error.localizedDescription)")
            }
        }
        
        // Since signIn() completion handler is called synchronously in this test, no further action is needed.
    }
    
    func testSignOut() {
        // Given
        
        // When
        mockAuthService.signOut { result in
            // Then (For synchronous testing, handle result directly here)
            switch result {
            case .success:
                XCTAssertNil(self.mockAuthService.currentUserUID)
            case .failure(let error):
                XCTFail("Sign out failed with error: \(error.localizedDescription)")
            }
        }
        
        // Since signOut() completion handler is called synchronously in this test, no further action is needed.
    }
    
    func testSignUp() {
        // Given
        let email = "test@example.com"
        let password = "password"
        var signUpResult: Result<UserModel, Error>?
        
        // When
        mockAuthService.signUp(email: email, password: password) { result in
            signUpResult = result
        }
        
        // Then
        switch signUpResult {
        case .success(let user):
            XCTAssertEqual(user.uid, "mocked_uid")
            XCTAssertEqual(user.email, email)
            XCTAssertNotNil(self.mockAuthService.currentUserUID)
        case .failure(let error):
            XCTFail("Sign up failed with error: \(error.localizedDescription)")
        case .none:
            XCTFail("No result returned from sign up")
        }
    }
    
    func testCheckEmailVerification() {
        // Given
        let user = User(uid: "mocked_uid", email: "test@example.com")
        var verificationResult: (Bool, Error?)?
        
        // When
        mockAuthService.checkEmailVerification(for: user) { verified, error in
            verificationResult = (verified, error)
        }
        
        // Then
        XCTAssertNotNil(verificationResult)
        XCTAssertTrue(verificationResult?.0 ?? false, "Email verification should be true in mock")
        XCTAssertNil(verificationResult?.1, "No error should be returned in mock")
    }


    func testFetchCustomerId() {
        let encodedEmail = "encoded_email_1"

        // Call the method under test
        mockAuthService.fetchCustomerId(encodedEmail: encodedEmail) { customerId in
            // Verify the result
            XCTAssertNotNil(customerId)
            XCTAssertEqual(customerId, "customer_id_1")
        }
    }

    func testIsEmailTaken() {
        let email = "test@example.com"

        // Call the method under test
        mockAuthService.isEmailTaken(email: email) { isTaken in
            // Verify the result
            XCTAssertFalse(isTaken)
        }
    }

    func testDeleteProductFromEncodedEmail() {
        let encodedEmail = "encoded_email_1"
        let productIdToDelete = "product_id_1"

        // Call the method under test
        mockAuthService.deleteProductFromEncodedEmail(encodedEmail: encodedEmail, productId: productIdToDelete)

        // Assert that the product was deleted from the mock database correctly
        if let customerData = mockAuthService.customersDatabase[encodedEmail],
           let products = customerData["products"] as? [String: [String: Any]] {
            XCTAssertNil(products[productIdToDelete])
        } else {
            XCTFail("Failed to delete product from mock database")
        }
    }
    
    func testRetrieveAllProductsFromEncodedEmail() {
        // Test data
        let email = "customer1@example.com"
        
        // Set up mock database with one product for this customer
        mockAuthService.customersDatabase = [
            SharedMethods.encodeEmail(email): [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": email,
                "isSignedIn": "true",
                "favouriteId": "favorite_id_1",
                "shoppingCartId": "shopping_cart_id_1",
                "products": [
                    "product_id_1": [
                        "productId": "product_id_1",
                        "productTitle": "Product 1",
                        "productVendor": "Vendor 1",
                        "productImage": "product_image_url_1"
                    ]
                ]
            ]
        ]
        
        // Call the method under test
        mockAuthService.retrieveAllProductsFromEncodedEmail(email: email) { products in
            // Assert that the products were retrieved correctly
            XCTAssertEqual(products.count, 1) // We expect exactly one product
            
            // Assert details of the retrieved product
            XCTAssertEqual(products[0].productId, "product_id_1")
            XCTAssertEqual(products[0].productTitle, "Product 1")
            XCTAssertEqual(products[0].productVendor, "Vendor 1")
            XCTAssertEqual(products[0].productImage, "product_image_url_1")
        }
    }
 

    func testFetchFavorites() {
        // Test data
        let email = "customer1@example.com"
        let productId1 = "product_id_1"
        let productId2 = "product_id_2"
        
        // Set up mock database with favorites for this customer
        mockAuthService.customersDatabase = [
            SharedMethods.encodeEmail(email): [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": email,
                "isSignedIn": "true",
                "favouriteId": "favorite_id_1",
                "shoppingCartId": "shopping_cart_id_1",
                "products": [
                    productId1: [
                        "productId": productId1,
                        "productTitle": "Product 1",
                        "productVendor": "Vendor 1",
                        "productImage": "product_image_url_1"
                    ],
                    productId2: [
                        "productId": productId2,
                        "productTitle": "Product 2",
                        "productVendor": "Vendor 2",
                        "productImage": "product_image_url_2"
                    ]
                ]
            ]
        ]
        
        // Call the method under test
        mockAuthService.fetchFavorites(email: email) { favorites in
            // Assert the favorites dictionary
            XCTAssertEqual(favorites.count, 2)
            XCTAssertTrue(favorites[productId1] ?? false)
            XCTAssertTrue(favorites[productId2] ?? false)
        }
    }

    func testCheckProductExists() {
        // Test data
        let email = "customer1@example.com"
        let productId = "product_id_1"
        
        // Set up mock database with the product for this customer
        mockAuthService.customersDatabase = [
            SharedMethods.encodeEmail(email): [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": email,
                "isSignedIn": "true",
                "favouriteId": "favorite_id_1",
                "shoppingCartId": "shopping_cart_id_1",
                "products": [
                    productId: [
                        "productId": productId,
                        "productTitle": "Product 1",
                        "productVendor": "Vendor 1",
                        "productImage": "product_image_url_1"
                    ]
                ]
            ]
        ]
        
        // Call the method under test
        mockAuthService.checkProductExists(email: email, productId: productId) { exists, error in
            // Assert that the product exists
            XCTAssertTrue(exists)
            XCTAssertNil(error)
        }
        
        // Call with a non-existent productId
        let nonExistentProductId = "non_existent_product_id"
        mockAuthService.checkProductExists(email: email, productId: nonExistentProductId) { exists, error in
            // Assert that the product does not exist
            XCTAssertFalse(exists)
            XCTAssertNil(error)
        }
    }

    func testCheckEmailSignInStatus() {
        // Test data
        let email = "customer1@example.com"
        
        // Set up mock database with customer signed in
        mockAuthService.customersDatabase = [
            SharedMethods.encodeEmail(email): [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": email,
                "isSignedIn": "true",
                "favouriteId": "favorite_id_1",
                "shoppingCartId": "shopping_cart_id_1"
            ]
        ]
        
        // Call the method under test
        mockAuthService.checkEmailSignInStatus(email: email) { isSignedIn in
            // Assert that the customer is signed in
            XCTAssertTrue(isSignedIn ?? false)
        }
        
        // Call with non-existent email
        let nonExistentEmail = "nonexistent@example.com"
        mockAuthService.checkEmailSignInStatus(email: nonExistentEmail) { isSignedIn in
            // Assert that the email does not exist in mock database
            XCTAssertNil(isSignedIn)
        }
    }

    
    func testFetchCustomerDataFromRealTimeDatabase() {
        // Test data
        let email = "customer1@example.com"
        
        // Set up mock database with customer data
        mockAuthService.customersDatabase = [
            SharedMethods.encodeEmail(email): [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": email,
                "isSignedIn": "true",
                "favouriteId": "favorite_id_1",
                "shoppingCartId": "shopping_cart_id_1"
            ]
        ]
        
        // Call the method under test
        mockAuthService.fetchCustomerDataFromRealTimeDatabase(forEmail: email) { customerData in
            // Assert the fetched customer data
            XCTAssertNotNil(customerData)
            XCTAssertEqual(customerData?.customerId, "customer_id_1")
            XCTAssertEqual(customerData?.name, "Customer 1")
            XCTAssertEqual(customerData?.email, email)
            XCTAssertEqual(customerData?.favouriteId, "favorite_id_1")
            XCTAssertEqual(customerData?.shoppingCartId, "shopping_cart_id_1")
        }
        
        // Call with non-existent email
        let nonExistentEmail = "nonexistent@example.com"
        mockAuthService.fetchCustomerDataFromRealTimeDatabase(forEmail: nonExistentEmail) { customerData in
            // Assert that customer data is nil for non-existent email
            XCTAssertNil(customerData)
        }
    }

    func testGetShoppingCartId() {
        // Test data
        let email = "customer1@example.com"
        let expectedShoppingCartId = "shopping_cart_id"
        
        // Set up mock database with customer data
        mockAuthService.customersDatabase = [
            SharedMethods.encodeEmail(email): [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": email,
                "isSignedIn": "true",
                "favouriteId": "favorite_id_1",
                "shoppingCartId": expectedShoppingCartId
            ]
        ]
        
        // Call the method under test
        mockAuthService.getShoppingCartId(email: email) { shoppingCartId, error in
            // Assert the fetched shopping cart ID
            XCTAssertEqual(shoppingCartId, expectedShoppingCartId)
            XCTAssertNil(error)
        }
        
        // Call with non-existent email
        let nonExistentEmail = "nonexistent@example.com"
        mockAuthService.getShoppingCartId(email: nonExistentEmail) { shoppingCartId, error in
            // Assert that shopping cart ID is nil for non-existent email
            XCTAssertNil(shoppingCartId)
            XCTAssertNil(error)
        }
    }


//----------------------------------------------------------------------------------
    
//
//        func testSetShoppingCartId() {
//            // Test data
//            let email = "customer1@example.com"
//            let shoppingCartId = "new_shopping_cart_id"
//
//            // Set up mock database with customer data
//            mockAuthService.customersDatabase = [
//                SharedMethods.encodeEmail(email): [
//                    "customerId": "customer_id_1",
//                    "name": "Customer 1",
//                    "email": email,
//                    "isSignedIn": "true",
//                    "favouriteId": "favorite_id_1",
//                    "shoppingCartId": "old_shopping_cart_id"
//                ]
//            ]
//
//            // Call the method under test
//            mockAuthService.setShoppingCartId(email: email, shoppingCartId: shoppingCartId) { error in
//                // Assert that setting shopping cart ID was successful
//                XCTAssertNil(error)
//
//                // Check updated value in mock database
//                if let customerData = self.mockAuthService.customersDatabase[SharedMethods.encodeEmail(email)],
//                   let updatedShoppingCartId = customerData["shoppingCartId"] as? String {
//                    XCTAssertEqual(updatedShoppingCartId, shoppingCartId)
//                } else {
//                    XCTFail("Failed to update shopping cart ID in mock database")
//                }
//            }
//        }
//
//        func testUpdateSignInStatus() {
//            // Test data
//            let email = "customer1@example.com"
//            let newSignInStatus = "false"
//
//            // Set up mock database with customer data
//            mockAuthService.customersDatabase = [
//                SharedMethods.encodeEmail(email): [
//                    "customerId": "customer_id_1",
//                    "name": "Customer 1",
//                    "email": email,
//                    "isSignedIn": "true",
//                    "favouriteId": "favorite_id_1",
//                    "shoppingCartId": "shopping_cart_id_1"
//                ]
//            ]
//
//            // Call the method under test
//            mockAuthService.updateSignInStatus(email: email, isSignedIn: newSignInStatus) { success in
//                // Assert that the update was successful
//                XCTAssertTrue(success)
//
//                // Check updated value in mock database
//                if let customerData = self.mockAuthService.customersDatabase[SharedMethods.encodeEmail(email)],
//                   let updatedSignInStatus = customerData["isSignedIn"] as? String {
//                    XCTAssertEqual(updatedSignInStatus, newSignInStatus)
//                } else {
//                    XCTFail("Failed to update sign-in status in mock database")
//                }
//            }
//        }
//
//        func testToggleFavorite() {
//            // Test data
//            let email = "customer1@example.com"
//            let productId = "product_id_1"
//            let productTitle = "Product 1"
//            let productVendor = "Vendor 1"
//            let productImage = "product_image_url_1"
//            let isFavorite = true // Assuming we are marking the product as favorite
//
//            // Set up mock database with initial product for this customer
//            mockAuthService.customersDatabase = [
//                SharedMethods.encodeEmail(email): [
//                    "customerId": "customer_id_1",
//                    "name": "Customer 1",
//                    "email": email,
//                    "isSignedIn": "true",
//                    "favouriteId": "favorite_id_1",
//                    "shoppingCartId": "shopping_cart_id_1",
//                    "products": [
//                        productId: [
//                            "productId": productId,
//                            "productTitle": productTitle,
//                            "productVendor": productVendor,
//                            "productImage": productImage
//                        ]
//                    ]
//                ]
//            ]
//
//            // Call the method under test
//            mockAuthService.toggleFavorite(email: email, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage, isFavorite: isFavorite) { error in
//                // Assert that there is no error returned
//                XCTAssertNil(error)
//
//                // Assert that the product is marked as favorite in the mock database
//                guard let customerData = self.mockAuthService.customersDatabase[SharedMethods.encodeEmail(email)],
//                      let productsData = customerData["products"] as? [String: [String: Any]],
//                      let updatedProduct = productsData[productId] else {
//                    XCTFail("Failed to retrieve updated product from mock database")
//                    return
//                }
//
//                // Verify the details of the updated product
//                XCTAssertEqual(updatedProduct["productId"] as? String, productId)
//                XCTAssertEqual(updatedProduct["productTitle"] as? String, productTitle)
//                XCTAssertEqual(updatedProduct["productVendor"] as? String, productVendor)
//                XCTAssertEqual(updatedProduct["productImage"] as? String, productImage)
//            }
//        }
//
//        func testAddProductToEncodedEmail() {
//                // Test data
//                let email = "customer2@example.com"
//                let productId = "product_id_2"
//                let productTitle = "Product 2"
//                let productSize = "Large"
//                let productColour = "Red"
//                let productVendor = "Vendor"
//                let productImage = "product_image_url_2"
//
//                // Call the method under test
//            mockAuthService.addProductToEncodedEmail(email: email, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage)
//
//                // Assert that the product was added to the mock database correctly
//                if let customerData = mockAuthService.customersDatabase[SharedMethods.encodeEmail(email)],
//                   let products = customerData["products"] as? [String: [String: Any]],
//                   let addedProduct = products[productId] {
//                    XCTAssertEqual(addedProduct["productId"] as? String, productId)
//                    XCTAssertEqual(addedProduct["productTitle"] as? String, productTitle)
//                    XCTAssertEqual(addedProduct["productSize"] as? String, productSize)
//                    XCTAssertEqual(addedProduct["productColour"] as? String, productColour)
//                    XCTAssertEqual(addedProduct["productImage"] as? String, productImage)
//                } else {
//                    XCTFail("Failed to add product to mock database")
//                }
//            }

//        func testSaveCustomerId() {
//            // Given
//            let name = "John Doe"
//            let email = "johndoe@example.com"
//            let id = "customer_id_2"
//            let favouriteId = "favorite_id_2"
//            let shoppingCartId = "shopping_cart_id_2"
//            let productId = "product_id_2"
//            let productTitle = "Product 2"
//            let productVendor = "Vendor 2"
//            let productImage = "product_image_url_2"
//            let isSignedIn = "true"
//    
//            // When
//            mockAuthService.saveCustomerId(name: name, email: email, id: id, favouriteId: favouriteId, shoppingCartId: shoppingCartId, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage, isSignedIn: isSignedIn)
//    
//    
//            XCTAssertNotNil(mockAuthService.customersDatabase["encoded_email_2"], "Customer data should be saved in the mock database")
//        }

    
}

struct User {
    let uid: String
    let email: String
}
