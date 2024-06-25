////
////  SignInViewModelTest.swift
////  ShopifyTests
////
////  Created by Sara Talat on 24/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify // Replace with your actual app module
//
//class SignInViewModelTests: XCTestCase {
//
//    var signInViewModel: SignInViewModel!
//    var authServiceMock: MockAuthService!
//    var networkServiceMock: MockNetworkService!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        authServiceMock = MockAuthService()
//        networkServiceMock = MockNetworkService()
//        signInViewModel = SignInViewModel(authService: authServiceMock, networkService: networkServiceMock)
//    }
//
//    override func tearDownWithError() throws {
//        signInViewModel = nil
//        authServiceMock = nil
//        networkServiceMock = nil
//        try super.tearDownWithError()
//    }
//
//    // MARK: - Initialization Tests
//
//    func testInitialization() throws {
//        XCTAssertNotNil(signInViewModel)
//        XCTAssertNil(signInViewModel.user)
//        XCTAssertEqual(signInViewModel.errorMessage, "")
//    }
//
//    // MARK: - Sign-in Tests
//
//    func testSignIn_Success() throws {
//        // Mock successful sign-in response
//        authServiceMock.signInResult = .success(User(uid: "dummyUID", email: "test@example.com"))
//
//        signInViewModel.signIn(email: "test@example.com", password: "password")
//
//        // Assert that user is set
//        XCTAssertNotNil(signInViewModel.user)
//        XCTAssertEqual(signInViewModel.user?.email, "test@example.com")
//    }
//
//    func testSignIn_Failure_WrongPassword() throws {
//        // Mock wrong password response
//        authServiceMock.signInResult = .failure(.wrongPassword)
//
//        signInViewModel.signIn(email: "test@example.com", password: "wrongpassword")
//
//        // Assert error message
//        XCTAssertEqual(signInViewModel.errorMessage, "Invalid email or password")
//    }
//
//    func testSignIn_Failure_NetworkError() throws {
//        // Mock network error response
//        authServiceMock.signInResult = .failure(.networkError)
//
//        signInViewModel.signIn(email: "test@example.com", password: "password")
//
//        // Assert error message
//        XCTAssertEqual(signInViewModel.errorMessage, "An error occurred. Please try again later.")
//    }
//
//    func testSignIn_EmptyEmail() throws {
//        signInViewModel.signIn(email: "", password: "password")
//
//        // Assert error message
//        XCTAssertEqual(signInViewModel.errorMessage, "Email cannot be empty")
//    }
//
//    func testSignIn_EmptyPassword() throws {
//        signInViewModel.signIn(email: "test@example.com", password: "")
//
//        // Assert error message
//        XCTAssertEqual(signInViewModel.errorMessage, "Password cannot be empty")
//    }
//
//    // MARK: - Update Sign-in Status Tests
//
//    func testUpdateSignInStatus_Success() throws {
//        authServiceMock.updateSignInStatusResult = true
//
//        signInViewModel.updateSignInStatus(email: "test@example.com")
//
//        // Assert success
//        // Ideally, you would check if some side effect occurred or use a mock to verify interaction
//    }
//
//    func testUpdateSignInStatus_Failure() throws {
//        authServiceMock.updateSignInStatusResult = false
//
//        signInViewModel.updateSignInStatus(email: "test@example.com")
//
//        // Assert failure
//        // Ideally, you would check if some side effect occurred or use a mock to verify interaction
//    }
//
//    // MARK: - Check Email Sign-in Status Tests
//
//    func testCheckEmailSignInStatus_SignedIn() throws {
//        authServiceMock.checkEmailSignInStatusResult = true
//
//        signInViewModel.checkEmailSignInStatus(email: "test@example.com")
//
//        // Assert actions when signed in
//        // Verify that appropriate actions are taken when signed in
//    }
//
//    func testCheckEmailSignInStatus_NotSignedIn() throws {
//        authServiceMock.checkEmailSignInStatusResult = false
//
//        signInViewModel.checkEmailSignInStatus(email: "test@example.com")
//
//        // Assert actions when not signed in
//        // Verify that appropriate actions are taken when not signed in
//    }
//
//    // MARK: - Post Draft Order For Shopping Cart Tests
//
//    func testPostDraftOrderForShoppingCart_Success() throws {
//        let draftOrder = signInViewModel.draftOrderDummyModel1()
//
//        networkServiceMock.requestFunctionResult = .success(OneDraftOrderResponse(draftOrder: DraftOrder(id: "12345")))
//
//        signInViewModel.postDraftOrderForShoppingCart(urlString: "https://example.com/draftorder", parameters: draftOrder, name: "Test Name", email: "test@example.com", completion: <#(OneDraftOrderResponse?) -> Void#>)
//
//        // Assert success
//        // Ideally, verify that the completion handler was called with the expected data
//    }
//
//    func testPostDraftOrderForShoppingCart_Failure() throws {
//        let draftOrder = signInViewModel.draftOrderDummyModel1()
//
//        networkServiceMock.requestFunctionResult = .failure(NetworkError.networkError)
//
//        signInViewModel.postDraftOrderForShoppingCart(urlString: "https://example.com/draftorder", parameters: draftOrder, name: "Test Name", email: "test@example.com", completion: <#(OneDraftOrderResponse?) -> Void#>)
//
//        // Assert failure
//        // Ideally, verify that the completion handler was called with nil or appropriate error
//    }
//
//    // MARK: - Fetch Customer ID Tests
//
//    func testFetchCustomerID_Success() throws {
//        authServiceMock.fetchCustomerDataResult = CustomerData(customerId: "12345", name: "Test Customer", email: "test@example.com", favouriteId: "98765", shoppingCartId: "54321")
//
//        signInViewModel.fetchCustomerID()
//
//        // Assert that customer data is correctly stored
//        XCTAssertEqual(SharedDataRepository.instance.customerId, "12345")
//        XCTAssertEqual(SharedDataRepository.instance.customerName, "Test Customer")
//        XCTAssertEqual(SharedDataRepository.instance.customerEmail, "test@example.com")
//        XCTAssertEqual(SharedDataRepository.instance.favouriteId, "98765")
//        XCTAssertEqual(SharedDataRepository.instance.shoppingCartId, "54321")
//    }
//
//    // MARK: - Helper Methods Tests
//
//    func testAddValueToUserDefaults() throws {
//        signInViewModel.addValueToUserDefaults(value: "test@example.com", forKey: "customerEmail")
//
//        // Assert that value is correctly stored in UserDefaults
//        XCTAssertEqual(UserDefaults.standard.string(forKey: "customerEmail"), "test@example.com")
//    }
//
//    func testSetDraftOrderId_Success() throws {
//        authServiceMock.setShoppingCartIdResult = nil
//
//        signInViewModel.setDraftOrderId(email: "test@example.com", shoppingCartID: "12345")
//
//        // Assert success
//        // Ideally, you would check if some side effect occurred or use a mock to verify interaction
//    }
//
//    func testSetDraftOrderId_Failure() throws {
//        authServiceMock.setShoppingCartIdResult = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
//
//        signInViewModel.setDraftOrderId(email: "test@example.com", shoppingCartID: "12345")
//
//        // Assert failure
//        // Ideally, you would check if some side effect occurred or use a mock to verify interaction
//    }
//
//    func testGetDraftOrderID_Success() throws {
//        authServiceMock.getShoppingCartIdResult = "54321"
//
//        signInViewModel.getDraftOrderID(email: "test@example.com")
//
//        // Assert that draft order ID is correctly retrieved and stored
//        XCTAssertEqual(SharedDataRepository.instance.draftOrderId, "54321")
//    }
//
//    func testGetDraftOrderID_Failure() throws {
//        authServiceMock.getShoppingCartIdResult = nil
//
//        signInViewModel.getDraftOrderID(email: "test@example.com")
//
//        // Assert failure
//        // Ideally, you would check if some side effect occurred or use a mock to verify interaction
//    }
//
//    // MARK: - Other Tests
//
//    // Additional tests for other methods in SignInViewModel as needed
//
//}
