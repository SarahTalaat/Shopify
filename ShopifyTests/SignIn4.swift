////
////  SignIn4.swift
////  ShopifyTests
////
////  Created by Sara Talat on 27/06/2024.
////
//
//import Foundation
//@testable import Shopify
//import XCTest
//
//class SignInViewModelTests: XCTestCase {
//
//    var viewModel: SignInViewModel!
//    var mockAuthService: MockFirebaseAuthService3!
//    var mockNetworkService: MockNetworkServiceAuthentication3!
//
//    override func setUp() {
//        super.setUp()
//        viewModel = SignInViewModel()
//        mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        mockNetworkService = MockNetworkServiceAuthentication3(forTesting: true)
//        viewModel.authService = mockAuthService
//        // Add this line to inject the mock network service
//        viewModel.networkService = mockNetworkService
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        mockAuthService = nil
//        mockNetworkService = nil
//        super.tearDown()
//    }
//
//    func testSignIn() {
//        // Arrange
//        let expectation = self.expectation(description: "Sign in expectation")
//        let email = "shopifyapp.test7@gmail.com"
//        let password = "@A123456"
//        let userModel = UserModel(uid: "1234567890", email: email)
//        mockAuthService.signInResult = .success(userModel)
//
//        // Act
//        viewModel.signIn(email: email, password: password)
//
//        // Assert
//        // Add assertions for signIn method
//        XCTAssertEqual(SharedDataRepository.instance.customerEmail, email)
//        expectation.fulfill()
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//    
//   
//    func testFetchCustomerID() {
//        // Arrange
//        let expectation = self.expectation(description: "Fetch customer ID expectation")
//        let email = "shopifyapp.test7@gmail.com"
//        let customerDataModel = CustomerData(customerId: "7533489127585", name: "Sarah", email: email, favouriteId: "", shoppingCartId: "1036337250465")
//        mockAuthService.fetchCustomerDataResult = .success(customerDataModel)
//
//        // Act
//        viewModel.fetchCustomerID()
//        
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
//            XCTAssertEqual(SharedDataRepository.instance.customerName, customerDataModel.name)
//            XCTAssertEqual(SharedDataRepository.instance.customerId, customerDataModel.customerId)
//            XCTAssertEqual(SharedDataRepository.instance.shoppingCartId, customerDataModel.shoppingCartId)
//            XCTAssertEqual(SharedDataRepository.instance.favouriteId, customerDataModel.favouriteId)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//
//    func testPostDraftOrderForShoppingCart() {
//        // Arrange
//        let expectation = self.expectation(description: "Post draft order expectation")
//        let urlString = APIConfig.draft_orders.url
//        let draftOrder1 = viewModel.draftOrderDummyModel1()
//        let response = OneDraftOrderResponse(draftOrder: OneDraftOrderResponseDetails(
//            id: 1036337250465,
//            note: nil,
//            email: nil,
//            taxesIncluded: nil,
//            currency: nil,
//            invoiceSentAt: nil,
//            createdAt: nil,
//            updatedAt: nil,
//            taxExempt: nil,
//            completedAt: nil,
//            name: nil,
//            status: nil,
//            lineItems: [],
//            shippingAddress: nil,
//            billingAddress: nil,
//            invoiceUrl: nil,
//            appliedDiscount: nil,
//            orderId: nil,
//            shippingLine: nil,
//            taxLines: nil,
//            tags: nil,
//            noteAttributes: nil,
//            totalPrice: "",
//            subtotalPrice: "",
//            totalTax: nil,
//            paymentTerms: nil,
//            adminGraphqlApiId: nil
//        ))
//        mockNetworkService.requestFunctionResult = .success(response)
//
//        // Act
//        viewModel.postDraftOrderForShoppingCart(urlString: urlString, parameters: draftOrder1 ?? [:], name: "Sarah", email: "shopifyapp.test7@gmail.com") { response in
//            // Assert
//            XCTAssertNotNil(response)
//            XCTAssertEqual(response?.draftOrder?.id, 1037003391137)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    func testGetDraftOrderID() {
//        // Arrange
//        let expectation = self.expectation(description: "Get draft order ID expectation")
//        let email = "shopifyapp.test7@gmail.com"
//        let shoppingCartId = "1036337250465"
//        mockAuthService.getShoppingCartIdResult = .success(shoppingCartId)
//
//        // Act
//        viewModel.getDraftOrderID(email: email)
//
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
//            XCTAssertEqual(SharedDataRepository.instance.draftOrderId, shoppingCartId)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//
//    func testSetDraftOrderId() {
//        // Arrange
//        let expectation = self.expectation(description: "Set draft order ID expectation")
//        let email = "shopifyapp.test7@gmail.com"
//        let shoppingCartId = "1036337250465"
//
//        // Act
//        viewModel.setDraftOrderId(email: email, shoppingCartID: shoppingCartId)
//
//        // Assert
//        // Add assertions for setDraftOrderId method
//        expectation.fulfill()
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//    func testUpdateSignInStatus() {
//        // Arrange
//        let expectation = self.expectation(description: "Update sign-in status expectation")
//        let email = "shopifyapp.test7@gmail.com"
//        mockAuthService.updateSignInStatusResult = .success(())
//
//        // Act
//        viewModel.updateSignInStatus(email: email)
//
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
//            // Add assertions for updateSignInStatus method
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//    
//    func testCheckEmailSignInStatus() {
//        // Arrange
//        let expectation = self.expectation(description: "Check email sign-in status expectation")
//        let email = "shopifyapp.test7@gmail.com"
//        mockAuthService.checkEmailSignInStatusResult = .success(true)
//
//        // Act
//        viewModel.checkEmailSignInStatus(email: email)
//
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline:.now() + 30.0) {
//            // Add assertions for checkEmailSignInStatus method
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//
//    func testAddValueToUserDefaults() {
//        // Arrange
//        let value = "testValue"
//        let key = "testKey"
//
//        // Act
//        viewModel.addValueToUserDefaults(value: value, forKey: key)
//
//        // Assert
//        XCTAssertEqual(UserDefaults.standard.string(forKey: key), value)
//    }
//
//    func testGetUserDraftOrderId() {
//        // Arrange
//        let expectation = self.expectation(description: "Get user draft order ID expectation")
//        let email = "shopifyapp.test7@gmail.com"
//
//        // Act
//        viewModel.getUserDraftOrderId()
//
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline:.now() + 30.0) {
//            // Add assertions for getUserDraftOrderId method
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//}
//
//class MockFirebaseAuthService3: FirebaseAuthService {
//
//    var signInResult: Result<UserModel, Error>?
//    var updateSignInStatusResult: Result<Void, Error>?
//    var fetchCustomerDataResult: Result<CustomerData, Error>?
//    var setShoppingCartIdResult: Result<Void, Error>?
//    var getShoppingCartIdResult: Result<String, Error>?
//    var checkEmailSignInStatusResult: Result<Bool, Error>?
//
//    override func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        if let signInResult = signInResult {
//            completion(signInResult)
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(.failure(NSError(domain: "MockAuthService", code: 500, userInfo: nil)))
//        }
//    }
//
//    override func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
//        if let updateSignInStatusResult = updateSignInStatusResult {
//            switch updateSignInStatusResult {
//            case .success:
//                completion(true)
//            case .failure:
//                completion(false)
//            }
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(false)
//        }
//    }
//
//    override func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData) -> Void) {
//        if let fetchCustomerDataResult = fetchCustomerDataResult {
//            switch fetchCustomerDataResult {
//            case .success(let customerData):
//                completion(customerData)
//            case .failure:
//                // Simulate default behavior or handle as needed
//                completion(CustomerData(customerId: "", name: "", email: "", favouriteId: "", shoppingCartId: ""))
//            }
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(CustomerData(customerId: "", name: "", email: "", favouriteId: "", shoppingCartId: ""))
//        }
//    }
//
//    override func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
//        if let setShoppingCartIdResult = setShoppingCartIdResult {
//            switch setShoppingCartIdResult {
//            case .success:
//                completion(nil)
//            case .failure(let error):
//                completion(error)
//            }
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(NSError(domain: "MockAuthService", code: 500, userInfo: nil))
//        }
//    }
//
//    override func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
//        if let getShoppingCartIdResult = getShoppingCartIdResult {
//            switch getShoppingCartIdResult {
//            case .success(let shoppingCartId):
//                completion(shoppingCartId, nil)
//            case .failure(let error):
//                completion(nil, error)
//            }
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(nil, NSError(domain: "MockAuthService", code: 500, userInfo: nil))
//        }
//    }
//
//    override func checkEmailSignInStatus(email: String, completion: @escaping (Bool) -> Void) {
//        if let checkEmailSignInStatusResult = checkEmailSignInStatusResult {
//            switch checkEmailSignInStatusResult {
//            case .success(let isSignedIn):
//                completion(isSignedIn)
//            case .failure:
//                // Simulate default behavior or handle as needed
//                completion(false)
//            }
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(false)
//        }
//    }
//}
//
//class MockNetworkServiceAuthentication3: NetworkServiceAuthentication {
//
//    var requestFunctionResult: Result<OneDraftOrderResponse, Error>?
//
//    func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<OneDraftOrderResponse, Error>) -> Void) {
//        if let requestFunctionResult = requestFunctionResult {
//            completion(requestFunctionResult)
//        } else {
//            // Simulate default behavior or handle as needed
//            completion(.failure(NSError(domain: "MockNetworkService", code: 500, userInfo: nil)))
//        }
//    }
//}
