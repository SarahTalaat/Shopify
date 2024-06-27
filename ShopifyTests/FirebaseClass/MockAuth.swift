//
//  MockAuth.swift
//  ShopifyTests
//
//  Created by Sara Talat on 25/06/2024.
//


import Foundation
import FirebaseAuth
@testable import Shopify


class MockAuthService: AuthServiceProtocol {
    var currentUserUID: String? // Simulated current user UID
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        // Simulate successful sign-in
        let user = UserModel(uid: "mocked_uid", email: email)
        currentUserUID = "mocked_uid"
        completion(.success(user))
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        // Simulate successful sign-out
        currentUserUID = nil
        completion(.success(()))
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        // Simulate successful sign-up
        let user = UserModel(uid: "mocked_uid", email: email)
        currentUserUID = "mocked_uid"
        completion(.success(user))
    }
    
    func checkEmailVerification(for user: User, completion: @escaping (Bool, Error?) -> Void) {
        // Simulate email verification (always true in mock)
        completion(true, nil)
    }
    
    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String, isSignedIn: String) {
        // Simulate saving customer data to a mock database (dictionary)
        var customersDatabase: [String: [String: Any]] = [
            // Simulate existing data
            "encoded_email_1": [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": "customer1@example.com",
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
        
        let encodedEmail = SharedMethods.encodeEmail(email)
        
        // Create or update customer data
        customersDatabase[encodedEmail] = [
            "customerId": id,
            "name": name,
            "email": email,
            "isSignedIn": isSignedIn,
            "favouriteId": favouriteId,
            "shoppingCartId": shoppingCartId,
            "products": [
                productId: [
                    "productId": productId,
                    "productTitle": productTitle,
                    "productVendor": productVendor,
                    "productImage": productImage
                ]
            ]
        ]
        
        print("MockAuthService: Saving customer data to mock database")
        // Print the updated database for verification (optional)
        print(customersDatabase)
    }

    func fetchCustomerId(encodedEmail: String, completion: @escaping (String?) -> Void) {
        // Simulate fetching customer ID from mock database (dictionary)
        let customersDatabase: [String: [String: Any]] = [
            // Simulate existing data
            "encoded_email_1": [
                "customerId": "customer_id_1",
                "name": "Customer 1",
                "email": "customer1@example.com",
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
        
        // Simulate asynchronous fetch operation
        DispatchQueue.global().async {
            // Simulate delay
            Thread.sleep(forTimeInterval: 1)
            
            // Fetch customer data from mock database
            if let customerData = customersDatabase[encodedEmail],
               let customerId = customerData["customerId"] as? String {
                completion(customerId)
            } else {
                completion(nil)
            }
        }
    }
    
    // Add more methods as needed for your tests
    
    // Example: Mock method to check if email is taken
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
        // Simulate checking if email is taken (mock implementation)
        DispatchQueue.global().async {
            // Simulate async operation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(false) // In the mock, assume email is not taken
            }
        }
    }
    
    var customersDatabase: [String: [String: Any]] = [
        "encoded_email_1": [
            "customerId": "customer_id_1",
            "name": "Customer 1",
            "email": "customer1@example.com",
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

    // Method to add a product to a customer's products in the mock database
    func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String) {
        let encodedEmail = SharedMethods.encodeEmail(email)

        // Check if customer exists in mock database
        guard var customerData = customersDatabase[encodedEmail] else {
            print("MockAuthService: Customer not found in mock database")
            return
        }

        // Ensure products dictionary is of the correct type [String: [String: Any]]
        if var products = customerData["products"] as? [String: [String: Any]] {
            // Add new product to customer's products or update existing product
            products[productId] = [
                "productId": productId,
                "productTitle": productTitle,
                "productVendor": productVendor,
                "productImage": productImage
            ]
            // Update customerData with the updated products dictionary
            customerData["products"] = products
        } else {
            // If products dictionary couldn't be cast, create a new one
            let newProducts: [String: [String: Any]] = [
                productId: [
                    "productId": productId,
                    "productTitle": productTitle,
                    "productVendor": productVendor,
                    "productImage": productImage
                ]
            ]
            // Set customerData with the new products dictionary
            customerData["products"] = newProducts
        }

        // Update mock database with modified customer data
        customersDatabase[encodedEmail] = customerData

        print("MockAuthService: Adding product to customer's products in mock database")
        // Print the updated database for verification (optional)
        print(customersDatabase)
    }
        // Mock method to delete a product from a customer's products in the mock database
        func deleteProductFromEncodedEmail(encodedEmail: String, productId: String) {
            guard var customerData = customersDatabase[encodedEmail] else {
                print("MockAuthService: Customer not found in mock database")
                return
            }
            
            // Ensure products dictionary is of the correct type [String: [String: Any]]
            if var products = customerData["products"] as? [String: [String: Any]] {
                // Remove product from customer's products
                products.removeValue(forKey: productId)
                // Update customerData with the modified products dictionary
                customerData["products"] = products
            } else {
                print("MockAuthService: Products not found for the customer in mock database")
            }
            
            // Update mock database with modified customer data
            customersDatabase[encodedEmail] = customerData
            
            print("MockAuthService: Deleting product from customer's products in mock database")
            // Print the updated database for verification (optional)
            print(customersDatabase)
        }
        
        // Mock method to retrieve all products of a customer from the mock database
        func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void) {
            var encodedEmail = SharedMethods.encodeEmail(email)
            
            // Check if customer exists in mock database
            guard let customerData = customersDatabase[encodedEmail],
                  let productsData = customerData["products"] as? [String: [String: Any]] else {
                print("MockAuthService: Customer not found or products not found in mock database")
                completion([])
                return
            }
            
            var products: [ProductFromFirebase] = []
            
            // Convert productsData into ProductFromFirebase objects
            for (_, productData) in productsData {
                if let productId = productData["productId"] as? String,
                   let productTitle = productData["productTitle"] as? String,
                   let productVendor = productData["productVendor"] as? String,
                   let productImage = productData["productImage"] as? String {
                    
                    let product = ProductFromFirebase(productId: productId,
                                                     productTitle: productTitle,
                                                     productVendor: productVendor,
                                                     productImage: productImage)
                    products.append(product)
                }
            }
            
            // Simulate asynchronous completion
            DispatchQueue.main.async {
                completion(products)
            }
        }
        
        // Mock method to toggle a product as favorite in the mock database
        func toggleFavorite(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
            var encodedEmail = SharedMethods.encodeEmail(email)
            
            // Check if customer exists in mock database
            guard var customerData = customersDatabase[encodedEmail] else {
                let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Customer not found in mock database"])
                completion(error)
                return
            }
            
            // Get reference to the product in the mock database
            var productsData = customerData["products"] as? [String: [String: Any]] ?? [:]
            var productData: [String: Any]
            
            if isFavorite {
                // If the product is to be marked as favorite, add it to productsData
                productData = [
                    "productId": productId,
                    "productTitle": productTitle,
                    "productVendor": productVendor,
                    "productImage": productImage
                ]
                productsData[productId] = productData
            } else {
                // If the product is to be unmarked as favorite, remove it from productsData
                productsData.removeValue(forKey: productId)
            }
            
            // Update customerData with the modified productsData
            customerData["products"] = productsData
            customersDatabase[encodedEmail] = customerData
            
            // Simulate asynchronous completion
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        
        // Mock method to fetch all favorite products of a customer from the mock database
        func fetchFavorites(email: String, completion: @escaping ([String: Bool]) -> Void) {
            var encodedEmail = SharedMethods.encodeEmail(email)
            
            // Check if customer exists in mock database
            guard let customerData = customersDatabase[encodedEmail],
                  let productsData = customerData["products"] as? [String: [String: Any]] else {
                print("MockAuthService: Customer not found or products not found in mock database")
                completion([:])
                return
            }
            
            var favorites: [String: Bool] = [:]
            
            // Iterate through productsData to find favorite products
            for (productId, _) in productsData {
                favorites[productId] = true
            }
            
            // Simulate asynchronous completion
            DispatchQueue.main.async {
                completion(favorites)
            }
        }
        
        // Mock method to check if a product exists in the mock database for a customer
        func checkProductExists(email: String, productId: String, completion: @escaping (Bool, Error?) -> Void) {
            var encodedEmail = SharedMethods.encodeEmail(email)
            
            // Check if customer exists in mock database
            guard let customerData = customersDatabase[encodedEmail],
                  let productsData = customerData["products"] as? [String: [String: Any]] else {
                let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Customer not found or products not found in mock database"])
                completion(false, error)
                return
            }
            
            // Check if productId exists in productsData
            if productsData[productId] != nil {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    
     var customersDatabase2: [String: [String: Any]] = [
           // Mock data for customers
           "encoded_email_1": [
               "customerId": "customer_id_1",
               "name": "Customer 1",
               "email": "customer1@example.com",
               "favouriteId": "favorite_id_1",
               "shoppingCartId": "shopping_cart_id_1",
               "isSignedIn": "true"
           ],
           "encoded_email_2": [
               "customerId": "customer_id_2",
               "name": "Customer 2",
               "email": "customer2@example.com",
               "favouriteId": "favorite_id_2",
               "shoppingCartId": "shopping_cart_id_2",
               "isSignedIn": "false"
           ]
       ]
       
       // MARK: - Authentication methods
       
       func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
           let encodedEmail = SharedMethods.encodeEmail(email)
           
           // Check if customer exists in mock database
           guard let customerData = customersDatabase[encodedEmail],
                 let isSignedIn = customerData["isSignedIn"] as? String else {
               completion(nil)
               return
           }
           completion(isSignedIn.lowercased() == "true")
       }
       
       func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
           let encodedEmail = SharedMethods.encodeEmail(email)
           customersDatabase[encodedEmail]?["isSignedIn"] = isSignedIn
           
           // Simulate update completion
           DispatchQueue.main.async {
               completion(true)
           }
       }
       
       // MARK: - Database operations
       
       func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
           let encodedEmail = SharedMethods.encodeEmail(email)
           
           // Check if customer exists in mock database
           guard let customerData = customersDatabase[encodedEmail],
                 let customerId = customerData["customerId"] as? String,
                 let name = customerData["name"] as? String,
                 let favouriteId = customerData["favouriteId"] as? String,
                 let shoppingCartId = customerData["shoppingCartId"] as? String else {
               completion(nil)
               return
           }
           
           let customer = CustomerData(customerId: customerId,
                                       name: name,
                                       email: email,
                                       favouriteId: favouriteId,
                                       shoppingCartId: shoppingCartId)
           
           // Simulate fetching data completion
           DispatchQueue.main.async {
               completion(customer)
           }
       }

       func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
           let encodedEmail = SharedMethods.encodeEmail(email)
           customersDatabase[encodedEmail]?["shoppingCartId"] = shoppingCartId
           
           // Simulate setting shopping cart ID completion
           DispatchQueue.main.async {
               completion(nil)
           }
       }
       
       func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
           let encodedEmail = SharedMethods.encodeEmail(email)
           guard let shoppingCartId = customersDatabase[encodedEmail]?["shoppingCartId"] as? String else {
               completion(nil, nil)
               return
           }
           
           // Simulate fetching shopping cart ID completion
           DispatchQueue.main.async {
               completion(shoppingCartId, nil)
           }
       }
    
    
    
    
}


//    func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String) {
//        // Simulate adding a product to a customer's products in a mock database (dictionary)
//        var customersDatabase: [String: [String: Any]] = [
//            // Simulate existing data
//            "encoded_email_1": [
//                "customerId": "customer_id_1",
//                "name": "Customer 1",
//                "email": "customer1@example.com",
//                "isSignedIn": "true",
//                "favouriteId": "favorite_id_1",
//                "shoppingCartId": "shopping_cart_id_1",
//                "products": [
//                    "product_id_1": [
//                        "productId": "product_id_1",
//                        "productTitle": "Product 1",
//                        "productVendor": "Vendor 1",
//                        "productImage": "product_image_url_1"
//                    ]
//                ]
//            ]
//        ]
//
//        let encodedEmail = SharedMethods.encodeEmail(email)
//
//        // Check if customer exists in mock database
//        guard var customerData = customersDatabase[encodedEmail] else {
//            print("MockAuthService: Customer not found in mock database")
//            return
//        }
//
//        // Ensure products dictionary is of the correct type [String: [String: Any]]
//        if var products = customerData["products"] as? [String: [String: Any]] {
//            // Add new product to customer's products or update existing product
//            products[productId] = [
//                "productId": productId,
//                "productTitle": productTitle,
//                "productVendor": productVendor,
//                "productImage": productImage
//            ]
//            // Update customerData with the updated products dictionary
//            customerData["products"] = products
//        } else {
//            // If products dictionary couldn't be cast, create a new one
//            let newProducts: [String: [String: Any]] = [
//                productId: [
//                    "productId": productId,
//                    "productTitle": productTitle,
//                    "productVendor": productVendor,
//                    "productImage": productImage
//                ]
//            ]
//            // Set customerData with the new products dictionary
//            customerData["products"] = newProducts
//        }
//
//        // Update mock database with modified customer data
//        customersDatabase[encodedEmail] = customerData
//
//        print("MockAuthService: Adding product to customer's products in mock database")
//        // Print the updated database for verification (optional)
//        print(customersDatabase)
//    }
