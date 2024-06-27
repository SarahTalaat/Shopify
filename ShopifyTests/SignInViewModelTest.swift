////
////  SignInViewModelTest.swift
////  ShopifyTests
////
////  Created by Sara Talat on 27/06/2024.
////
//
//import Foundation
//
//import XCTest
//@testable import Shopify
//
//
//
//class SignInViewModelTests: XCTestCase {
//
//    var viewModel: SignInViewModel!
//    var mockFirebaseAuthService: MockAuthService2!
//    var mockNetworkService: NetworkServiceMock!
//
//    override func setUp() {
//        super.setUp()
//        mockFirebaseAuthService = MockAuthService2()
//        mockNetworkService = NetworkServiceMock()
//        viewModel = SignInViewModel()
//    }
//
//    override func tearDown() {
//        super.tearDown()
//        viewModel = nil
//        mockFirebaseAuthService = nil
//        mockNetworkService = nil
//    }
//
//
//
//    func testCheckEmailSignInStatus_NotSignedIn() {
//        // Set up mock result
//        mockFirebaseAuthService.checkEmailSignInStatusResult = false
//
//        // Call check email sign in status function
//        viewModel.checkEmailSignInStatus(email: "email")
//
//        // Verify sign-in status is not updated
//        XCTAssertFalse(SharedDataRepository.instance.isSignedIn)
//    }
//
//    func testPostDraftOrderForShoppingCart_Success() {
//        // Set up mock result
//        let draftOrderDetails = OneDraftOrderResponseDetails(id: 123, note: nil, email: nil, taxesIncluded: nil, currency: nil, invoiceSentAt: nil, createdAt: nil, updatedAt: nil, taxExempt: nil, completedAt: nil, name: nil, status: nil, lineItems: [], shippingAddress: nil, billingAddress: nil, invoiceUrl: nil, appliedDiscount: nil, orderId: nil, shippingLine: nil, taxLines: nil, tags: nil, noteAttributes: nil, totalPrice: "", subtotalPrice: "", totalTax: nil, paymentTerms: nil, adminGraphqlApiId: nil)
//        let response = OneDraftOrderResponse(draftOrder: draftOrderDetails)
//        mockNetworkService.result = .success(response)
//
//        // Call post draft order function
//        viewModel.postDraftOrderForShoppingCart(urlString: "url", parameters: [:], name: "name", email: "email") { response in
//            // Verify response is set
//            XCTAssertNotNil(response)
//            XCTAssertEqual(response?.draftOrder?.id, 123)
//        }
//    }
//
//    func testPostDraftOrderForShoppingCart_Failure() {
//        // Set up mock result
//        let error = NSError(domain: "Error", code: 0, userInfo: nil)
//        mockNetworkService.result = .failure(error)
//
//        // Call post draft order function
//        viewModel.postDraftOrderForShoppingCart(urlString: "url", parameters: [:], name: "name", email: "email") { response in
//            // Verify response is nil
//            XCTAssertNil(response)
//        }
//    }
//
//    func testDraftOrderDummyModel1() {
//        // Call draft order dummy model 1 function
//        let draftOrder = viewModel.draftOrderDummyModel1()
//
//        // Verify draft order is not nil
//        XCTAssertNotNil(draftOrder)
//    }
//
//    func testDraftOrderDummyModel2() {
//        // Call draft order dummy model 2 function
//        let draftOrder = viewModel.draftOrderDummyModel2()
//
//        // Verify draft order is not nil
//        XCTAssertNotNil(draftOrder)
//    }
//
//    func testAddValueToUserDefaults() {
//        // Call add value to user defaults function
//        viewModel.addValueToUserDefaults(value: "value", forKey: "key")
//
//        // Verify value is set in user defaults
//        XCTAssertEqual(UserDefaults.standard.value(forKey: "key") as? String, "value")
//    }
//}
//
//
//class MockAuthService2 {
//    var signInResult: Result<UserModel, Error>?
//    var updateSignInStatusResult: Bool = false
//    var checkEmailSignInStatusResult: Bool?
//    var fetchCustomerDataResult: CustomerData?
//    var setShoppingCartIdError: Error?
//    var getShoppingCartIdResult: String?
//
//    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        if let result = signInResult {
//            completion(result)
//        }
//    }
//
//    func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
//        completion(updateSignInStatusResult)
//    }
//
//    func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
//        completion(checkEmailSignInStatusResult)
//    }
//
//    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
//        completion(fetchCustomerDataResult)
//    }
//
//    func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
//        completion(setShoppingCartIdError)
//    }
//
//    func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
//        completion(getShoppingCartIdResult, nil)
//    }
//}
//
//
////
////class SignInViewModelTests: XCTestCase {
////
////    var viewModel: SignInViewModel!
////    var mockFirebaseAuthService: MockFirebaseAuthService!
////    var mockNetworkService: NetworkServiceMock!
////
////    override func setUp() {
////        super.setUp()
////        viewModel = SignInViewModel()
////        mockFirebaseAuthService = MockFirebaseAuthService()
////        mockNetworkService = NetworkServiceMock()
////
////    }
////
////    override func tearDown() {
////        super.tearDown()
////        // Reset mock services
////
////    }
////
////    func testSignInSuccess() {
////        // Set up mock result
////        let user = UserModel(uid: "uid", email: "email")
////        mockFirebaseAuthService.signInResult = .success(user)
////
////        // Call sign in function
////        viewModel.signIn(email: "email", password: "password")
////
////        // Verify user is set
////        XCTAssertNotNil(viewModel.user)
////        XCTAssertEqual(viewModel.user?.uid, "uid")
////        XCTAssertEqual(viewModel.user?.email, "email")
////    }
////
////    func testSignInFailure() {
////        // Set up mock result
////        let error = NSError(domain: "Error", code: 0, userInfo: nil)
////        mockFirebaseAuthService.signInResult = .failure(error)
////
////        // Call sign in function
////        viewModel.signIn(email: "email", password: "password")
////
////        // Verify error message is set
////        XCTAssertNotNil(viewModel.errorMessage)
////        XCTAssertEqual(viewModel.errorMessage, "An error occurred. Please try again later.")
////    }
////
////    func testUpdateSignInStatus() {
////        // Set up mock result
////        mockFirebaseAuthService.updateSignInStatusResult = .success(())
////
////        // Call update sign in status function
////        viewModel.updateSignInStatus(email: "email")
////
////        // Verify sign-in status is updated
////        XCTAssertTrue(SharedDataRepository.instance.isSignedIn)
////    }
////
////    func testCheckEmailSignInStatus() {
////        // Set up mock result
////        mockFirebaseAuthService.checkEmailSignInStatusResult = (true, nil)
////
////        // Call check email sign in status function
////        viewModel.checkEmailSignInStatus(email: "email")
////
////        // Verify sign-in status is updated
////        XCTAssertTrue(SharedDataRepository.instance.isSignedIn)
////    }
////
////    func testPostDraftOrderForShoppingCartSuccess() {
////        // Set up mock result
////        let draftOrderDetails = OneDraftOrderResponseDetails(id: 123, note: nil, email: nil, taxesIncluded: nil, currency: nil, invoiceSentAt: nil, createdAt: nil, updatedAt: nil, taxExempt: nil, completedAt: nil, name: nil, status: nil, lineItems: [], shippingAddress: nil, billingAddress: nil, invoiceUrl: nil, appliedDiscount: nil, orderId: nil, shippingLine: nil, taxLines: nil, tags: nil, noteAttributes: nil, totalPrice: "", subtotalPrice: "", totalTax: nil, paymentTerms: nil, adminGraphqlApiId: nil)
////        let response = OneDraftOrderResponse(draftOrder: draftOrderDetails)
////        mockNetworkService.result = .success(response)
////
////        // Call post draft order function
////        viewModel.postDraftOrderForShoppingCart(urlString: "url", parameters: [:], name: "name", email: "email") { response in
////            // Verify response is set
////            XCTAssertNotNil(response)
////            XCTAssertEqual(response?.draftOrder?.id, 123)
////        }
////    }
////
////    func testPostDraftOrderForShoppingCartFailure() {
////        // Set up mock result
////        let error = NSError(domain: "Error", code: 0, userInfo: nil)
////        mockNetworkService.result = .failure(error)
////
////        // Call post draft order function
////        viewModel.postDraftOrderForShoppingCart(urlString: "url", parameters: [:], name: "name", email: "email") { response in
////            // Verify response is nil
////            XCTAssertNil(response)
////        }
////    }
//////
//////    func testFetchCustomerID() {
//////        // Set up mock result
//////        let customerDataModel = CustomerData(customerId: "customerId", name: "name", email: "email", favouriteId: "favouriteId", shoppingCartId: "shoppingCartId")
//////        mockFirebaseAuthService.fetchCustomerDataResult = customerDataModel
//////
//////        // Call fetch customer ID function
//////        viewModel.fetchCustomerID()
//////
//////        // Verify customer ID is set
//////        XCTAssertEqual(SharedDataRepository.instance.customerId, "customerId")
//////    }
////
////    func testDraftOrderDummyModel1() {
////        // Call draft order dummy model 1 function
////        let draftOrder = viewModel.draftOrderDummyModel1()
////
////        // Verify draft order is not nil
////        XCTAssertNotNil(draftOrder)
////    }
////
////    func testDraftOrderDummyModel2() {
////        // Call draft order dummy model 2 function
////        let draftOrder = viewModel.draftOrderDummyModel2()
////
////        // Verify draft order is not nil
////        XCTAssertNotNil(draftOrder)
////    }
////
////    func testAddValueToUserDefaults() {
////        // Call add value to user defaults function
////        viewModel.addValueToUserDefaults(value: "value", forKey: "key")
////
////        // Verify value is set in user defaults
////        XCTAssertEqual(UserDefaults.standard.value(forKey: "key") as? String, "value")
////    }
////}
