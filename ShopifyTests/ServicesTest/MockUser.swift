////////
////////  MockUser.swift
////////  ShopifyTests
////////
////////  Created by Sara Talat on 24/06/2024.
////////
//////
//////import Foundation
//////
//////import FirebaseAuth
//////
//////protocol UserProtocol {
//////    var uid: String { get }
//////    var email: String? { get }
//////    var isEmailVerified: Bool { get }
//////
//////    func sendEmailVerification(completion: ((Error?) -> Void)?)
//////    func reload(completion: ((Error?) -> Void)?)
//////}
//////
//////extension MockUser: UserProtocol {}
//////
//////class MockUser {
//////    var uid: String = "testUid"
//////    var email: String? = "test@example.com"
//////    var isEmailVerified: Bool = true
//////
//////    func sendEmailVerification(completion: ((Error?) -> Void)? = nil) {
//////        completion?(nil)
//////    }
//////
//////    func reload(completion: ((Error?) -> Void)? = nil) {
//////        completion?(nil)
//////    }
//////}
////
////@testable import Shopify
////import XCTest
////import Firebase
////import FirebaseDatabase
////import Foundation
////import FirebaseDatabase
////
////// MARK: - MockDatabaseReference
////
////class MockDatabaseReference: DatabaseReference {
////    // Properties to track method invocations
////    var setValueCalled = false
////    var removeValueCalled = false
////    var observeSingleEventCalled = false
////
////    // Data snapshot to simulate Firebase data
////    var observeSingleEventSnapshot: DataSnapshot?
////
////    // Captured data for assertions
////    var capturedCustomerData: [String: Any]?
////
////    // Child references
////    private var children = [String: MockDatabaseReference]()
////
////    // MARK: - Method Overrides
////
////    override func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
////        setValueCalled = true
////        capturedCustomerData = value as? [String: Any]
////        // Simulate success for testing
////        block(nil, self)
////    }
////
////    override func removeValue(completionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
////        removeValueCalled = true
////        // Simulate success for testing
////        block(nil, self)
////    }
////
////    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
////        observeSingleEventCalled = true
////        if let snapshot = observeSingleEventSnapshot {
////            block(snapshot)
////        }
////    }
////
////    override func child(_ pathString: String) -> DatabaseReference {
////        if let childRef = children[pathString] {
////            return childRef
////        } else {
////            let childRef = MockDatabaseReference()
////            children[pathString] = childRef
////            return childRef
////        }
////    }
////}
////
////
////protocol FirebaseDatabaseProtocol {
////    func reference() -> DatabaseReference
////}
////
////// MARK: - MockFirebaseDatabase
////
////class MockFirebaseDatabase: FirebaseDatabaseProtocol {
////    func reference() -> DatabaseReference {
////        return MockDatabaseReference()
////    }
////}
////// Mock DataSnapshot
////class MockDataSnapshot: DataSnapshot {
////    private var mockData: [String: Any]
////
////    init(mockData: [String: Any] = [:]) {
////        self.mockData = mockData
////        super.init()
////    }
////
////    override var value: Any? {
////        return mockData
////    }
////
////    override func childSnapshot(forPath childPathString: String) -> DataSnapshot {
////        let childData = mockData[childPathString] as? [String: Any] ?? [:]
////        return MockDataSnapshot(mockData: childData)
////    }
////}
////
////class YourFirebaseManager {
////    var database: FirebaseDatabaseProtocol
////
////    init(database: FirebaseDatabaseProtocol = MockFirebaseDatabase()) {
////        self.database = database
////    }
////
////    func saveCustomerId(
////        name: String,
////        email: String,
////        id: String,
////        favouriteId: String,
////        shoppingCartId: String,
////        productId: String,
////        productTitle: String,
////        productSize: String,
////        productColour: String,
////        productImage: String,
////        isSignedIn: String
////    ) {
////        let encodedEmail = SharedMethods.encodeEmail(email)
////        let customerRef = database.reference().child("customers").child(encodedEmail)
////
////        let customerData: [String: Any] = [
////            "customerId": id,
////            "email": email,
////            "name": name,
////            "isSignedIn": isSignedIn,
////            "favouriteId": favouriteId,
////            "shoppingCartId": shoppingCartId,
////            "products": [
////                productId: [
////                    "productId": productId,
////                    "productTitle": productTitle,
////                    "productSize": productSize,
////                    "productColour": productColour,
////                    "productImage": productImage
////                ]
////            ]
////        ]
////
////        customerRef.setValue(customerData) { (error, _) in
////            if let error = error {
////                print("Error saving customer data: \(error)")
////            } else {
////                print("Customer data saved successfully")
////            }
////        }
////    }
////
////    func deleteProductFromEncodedEmail(encodedEmail: String, productId: String) {
////        let ref = database.reference()
////        let customersRef = ref.child("customers")
////        let customerRef = customersRef.child(encodedEmail)
////        let productsRef = customerRef.child("products")
////
////        productsRef.child(productId).removeValue { error, _ in
////            if let error = error {
////                print("Error deleting product from Firebase: \(error.localizedDescription)")
////            } else {
////                print("Product deleted successfully from Firebase")
////            }
////        }
////    }
////
////    func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void) {
////        let ref = database.reference()
////        let customersRef = ref.child("customers")
////        let encodedEmail = SharedMethods.encodeEmail(email)
////        let customerRef = customersRef.child(encodedEmail)
////        let productsRef = customerRef.child("products")
////
////        productsRef.observeSingleEvent(of: .value) { snapshot in
////            var products: [ProductFromFirebase] = []
////
////            for child in snapshot.children {
////                if let childSnapshot = child as? DataSnapshot,
////                   let productData = childSnapshot.value as? [String: Any],
////                   let productId = productData["productId"] as? String,
////                   let productTitle = productData["productTitle"] as? String,
////                   let productVendor = productData["productVendor"] as? String,
////                   let productImage = productData["productImage"] as? String {
////
////                    let product = ProductFromFirebase(
////                        productId: productId,
////                        productTitle: productTitle,
////                        productVendor: productVendor,
////                        productImage: productImage
////                    )
////
////                    products.append(product)
////                }
////            }
////
////            completion(products)
////        }
////    }
////}
////class YourTests: XCTestCase {
////    var firebaseManager: YourFirebaseManager!
////    var mockDatabase: MockFirebaseDatabase!
////
////    override func setUp() {
////        super.setUp()
////        mockDatabase = MockFirebaseDatabase()
////        firebaseManager = YourFirebaseManager(database: mockDatabase)
////    }
////
////    override func tearDown() {
////        firebaseManager = nil
////        mockDatabase = nil
////        super.tearDown()
////    }
////
////    func testSaveCustomerId() {
////        // Set up the mock database
////        let mockDatabase = MockFirebaseDatabase()
////        firebaseManager.database = mockDatabase
////
////        // Call your method under test
////        firebaseManager.saveCustomerId(
////            name: "John Doe",
////            email: "john.doe@example.com",
////            id: "12345",
////            favouriteId: "fav123",
////            shoppingCartId: "cart123",
////            productId: "p1",
////            productTitle: "Product 1",
////            productSize: "M",
////            productColour: "Red",
////            productImage: "image-url",
////            isSignedIn: "true"
////        )
////
////        let encodedEmail = SharedMethods.encodeEmail("john.doe@example.com")
////        print("Encoded email: \(encodedEmail)")
////
////        // Verify the mock database state after calling saveCustomerId
////        guard let customersRef = mockDatabase.reference().child("customers") as? MockDatabaseReference,
////              let customerRef = customersRef.child(encodedEmail) as? MockDatabaseReference else {
////            XCTFail("Failed to cast DatabaseReference to MockDatabaseReference or retrieve references")
////            return
////        }
////
////        print("Set value called: \(customerRef.setValueCalled)")
////        print("Captured customer data: \(String(describing: customerRef.capturedCustomerData))")
////
////        // Assert based on captured data
////        XCTAssertTrue(customerRef.setValueCalled, "setValue should have been called")
////        XCTAssertNotNil(customerRef.capturedCustomerData, "Customer data should not be nil")
////
////        if let customerData = customerRef.capturedCustomerData {
////            XCTAssertEqual(customerData["customerId"] as? String, "12345")
////            XCTAssertEqual(customerData["email"] as? String, "john.doe@example.com")
////            XCTAssertEqual(customerData["name"] as? String, "John Doe")
////            XCTAssertEqual(customerData["isSignedIn"] as? String, "true")
////            XCTAssertEqual(customerData["favouriteId"] as? String, "fav123")
////            XCTAssertEqual(customerData["shoppingCartId"] as? String, "cart123")
////
////            guard let productsData = customerData["products"] as? [String: Any],
////                  let productData = productsData["p1"] as? [String: Any] else {
////                XCTFail("Failed to extract product data")
////                return
////            }
////
////            XCTAssertEqual(productData["productId"] as? String, "p1")
////            XCTAssertEqual(productData["productTitle"] as? String, "Product 1")
////            XCTAssertEqual(productData["productSize"] as? String, "M")
////            XCTAssertEqual(productData["productColour"] as? String, "Red")
////            XCTAssertEqual(productData["productImage"] as? String, "image-url")
////        }
////    }
////
////    func testDeleteProductFromEncodedEmail() {
////        // Call your method under test
////        firebaseManager.deleteProductFromEncodedEmail(encodedEmail: "encodedEmail", productId: "p1")
////
////        // Assert based on mockDatabase behaviors
////        guard let productsRef = mockDatabase.reference().child("customers").child("encodedEmail").child("products") as? MockDatabaseReference else {
////            XCTFail("Failed to cast DatabaseReference to MockDatabaseReference")
////            return
////        }
////
////        XCTAssertTrue(productsRef.removeValueCalled, "removeValue should have been called")
////    }
////
////    func testRetrieveAllProductsFromEncodedEmail() {
////        // Set up mock snapshot data for testing
////        let mockSnapshotData: [String: Any] = [
////            "p1": [
////                "productId": "p1",
////                "productTitle": "Product 1",
////                "productVendor": "Vendor A",
////                "productImage": "image-url"
////            ],
////            "p2": [
////                "productId": "p2",
////                "productTitle": "Product 2",
////                "productVendor": "Vendor B",
////                "productImage": "image-url"
////            ]
////        ]
////
////        // Create mock snapshot
////        let mockSnapshot = MockDataSnapshot(mockData: mockSnapshotData)
////
////        // Set mock snapshot for observeSingleEvent in mockDatabase
////        if let productsRef = mockDatabase.reference().child("customers").child("encodedEmail").child("products") as? MockDatabaseReference {
////            productsRef.observeSingleEventSnapshot = mockSnapshot
////        } else {
////            XCTFail("Failed to set mock snapshot for observeSingleEvent")
////        }
////
////        // Call your method under test
////        firebaseManager.retrieveAllProductsFromEncodedEmail(email: "john.doe@example.com") { products in
////            // Assert based on the returned products
////            XCTAssertEqual(products.count, 2, "Expected 2 products")
////            XCTAssertEqual(products[0].productId, "p1", "Expected productId 'p1'")
////            XCTAssertEqual(products[1].productTitle, "Product 2", "Expected product title 'Product 2'")
////        }
////
////        // Alternatively, you can directly check mockDatabase properties if available
////    }
////}
////
////
////
////
////
////// Mock YourFirebaseManager with mock dependencies
////class MockYourFirebaseManager: YourFirebaseManager {
////    override init(database: FirebaseDatabaseProtocol) {
////        super.init(database: database)
////    }
////
////    convenience init() {
////        self.init(database: MockFirebaseDatabase())
////    }
////}
//
//import XCTest
//@testable import Shopify
//import Firebase
//import FirebaseDatabase
//import FirebaseAuth
//
//class CustomerTests: XCTestCase {
//    
//    var mockFirebaseRef: MockDatabaseReference!
//    var mockSharedMethods: MockSharedMethods!
//    
//    override func setUp() {
//        super.setUp()
//        
//        // Set up mocks
//        let mockViewController = UIViewController()
//        mockFirebaseRef = MockDatabaseReference()
//        mockSharedMethods = MockSharedMethods(viewController: mockViewController)
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//        
//        // Clean up mocks
//        mockFirebaseRef = nil
//        mockSharedMethods = nil
//    }
//    
//    func testSaveCustomerId() {
//        // Given
//        let name = "John Doe"
//        let email = "johndoe@example.com"
//        let id = "customer_id_123"
//        let favouriteId = "favorite_id_456"
//        let shoppingCartId = "cart_id_789"
//        let productId = "product_id_abc"
//        let productTitle = "Product Title"
//        let productVendor = "Product Vendor"
//        let productImage = "product_image.jpg"
//        let isSignedIn = "true"
//        
//        let expectedCustomerData: [String: Any] = [
//            "customerId": id,
//            "email": email,
//            "name": name,
//            "isSignedIn": isSignedIn,
//            "favouriteId": favouriteId,
//            "shoppingCartId": shoppingCartId,
//            "products": [
//                productId: [
//                    "productId": productId,
//                    "productTitle": productTitle,
//                    "productVendor": productVendor,
//                    "productImage": productImage
//                ]
//            ]
//        ]
//        
//        // When
//        mockSharedMethods.encodeEmailResult = "encoded_email"
//        mockFirebaseRef.setValueCompletionHandler = { (data, error) in
//            XCTAssertNil(error)
//            XCTAssertEqual(data as? [String: Any], expectedCustomerData)
//        }
//        
//        let sut = CustomerManager(firebaseRef: mockFirebaseRef, sharedMethods: mockSharedMethods)
//        sut.saveCustomerId(name: name, email: email, id: id, favouriteId: favouriteId, shoppingCartId: shoppingCartId, productId: productId, productTitle: productTitle, productVendor: productVendor, productImage: productImage, isSignedIn: isSignedIn)
//        
//        // Then
//        XCTAssertTrue(mockFirebaseRef.setValueCalled)
//        XCTAssertTrue(mockSharedMethods.encodeEmailCalled)
//    }
//}
//class MockDatabaseReference: DatabaseReference {
//    var setValueCalled = false
//    var setValueCompletionHandler: ((Any?, Error?) -> Void)?
//    
//    override func setValue(_ value: Any, withCompletionBlock block: ((Error?) -> Void)?) {
//        setValueCalled = true
//        setValueCompletionHandler?(value, nil)
//        block?(nil)
//    }
//    
//    override func child(_ path: String) -> DatabaseReference {
//        return self
//    }
//}
//
//class MockSharedMethods: SharedMethods {
//    var encodeEmailCalled = false
//    var encodeEmailResult: String?
//    
//    override func encodeEmail(_ email: String) -> String {
//        encodeEmailCalled = true
//        return encodeEmailResult ?? "encoded_email"
//    }
//    
//    
//}
