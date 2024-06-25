//////
//////  SignInVMTest.swift
//////  ShopifyTests
//////
//////  Created by Sara Talat on 25/06/2024.
//////
////
////import Foundation
////
////import XCTest
////@testable import Shopify
////
////class SignInViewModelTests: XCTestCase {
////    var viewModel: SignInViewModel!
////    var mockAuthService: MockAuthService!
////
////    override func setUp() {
////        super.setUp()
////        mockAuthService = MockAuthService()
////        viewModel = SignInViewModel(authServiceProtocol: mockAuthService, networkServiceAuthenticationProtocol: MockNetworkService())
////    }
////
////    override func tearDown() {
////        viewModel = nil
////        mockAuthService = nil
////        super.tearDown()
////    }
////
////    func testUpdateSignInStatus_Success() {
////        // Arrange
////        mockAuthService.updateSignInStatusSuccess = true
////        let email = "test@example.com"
////        var successMessage: String?
////
////        // Act
////        viewModel.updateSignInStatus(email: email)
////
////        // Assert
////        XCTAssertEqual(successMessage, "Sign-in status updated successfully.")
////    }
////
////    func testUpdateSignInStatus_Failure() {
////        // Arrange
////        mockAuthService.updateSignInStatusSuccess = false
////        let email = "test@example.com"
////        var failureMessage: String?
////
////        // Act
////        viewModel.updateSignInStatus(email: email)
////
////        // Assert
////        XCTAssertEqual(failureMessage, "Failed to update sign-in status.")
////    }
////}
//
//
//import XCTest
//@testable import Shopify
//
//
//// Mock AuthServiceProtocol for testing SignInViewModel
//class MockAuthServiceProtocol {
//
//    var signInResult: Result<UserModel, Error>?
//    var updateSignInStatusResult: Bool = true
//    var checkEmailSignInStatusResult: Bool = false
//    var fetchCustomerDataResult: CustomerData?
//    var setShoppingCartIdError: Error?
//    var getShoppingCartIdResult: (String?, Error?) = (nil, nil)
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
//        completion(getShoppingCartIdResult.0, getShoppingCartIdResult.1)
//    }
//}
//
//// Mock NetworkServiceAuthenticationProtocol for testing SignInViewModel
//class MockNetworkServiceAuthenticationProtocol {
//
//    var requestFunctionResult: Result<OneDraftOrderResponse, Error>?
//
//    func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<OneDraftOrderResponse, Error>) -> Void) {
//        if let result = requestFunctionResult {
//            completion(result)
//        }
//    }
//}
//
//// Mock UserModel for testing purposes
//struct MockUserModel: UserModel {
//    var uid: String
//    var email: String
//}
//
//// Mock OneDraftOrderResponse for testing purposes
//struct MockOneDraftOrderResponse: OneDraftOrderResponse {
//    var draftOrder: DraftOrder?
//}
//
//// Mock OneDraftOrderResponse for testing purposes
//struct MockDraftOrder: DraftOrder {
//    var id: String?
//}
//
//// Mock constants
//struct MockConstants {
//    static let testEmail = "test@example.com"
//    static let testPassword = "password"
//}
//
//// Mock implementation for SharedDataRepository
//class MockSharedDataRepository: SharedDataRepository {
//    static var instance = MockSharedDataRepository()
//    override var customerEmail: String? {
//        get { return super.customerEmail }
//        set { super.customerEmail = newValue }
//    }
//    // Add other properties as needed for testing
//}
//
//class SignInViewModelTests: XCTestCase {
//
//    var viewModel: SignInViewModel!
//    var mockAuthService: MockAuthServiceProtocol!
//    var mockNetworkService: MockNetworkServiceAuthenticationProtocol!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//
//        mockAuthService = MockAuthServiceProtocol()
//        mockNetworkService = MockNetworkServiceAuthenticationProtocol()
//
//        viewModel = SignInViewModel(
//            authServiceProtocol: mockAuthService,
//            networkServiceAuthenticationProtocol: mockNetworkService
//        )
//    }
//
//    override func tearDownWithError() throws {
//        viewModel = nil
//        mockAuthService = nil
//        mockNetworkService = nil
//
//        try super.tearDownWithError()
//    }
//
//    func testSignInSuccess() {
//        // Given
//        let expectedUser = MockUserModel(uid: "test_uid", email: MockConstants.testEmail)
//        mockAuthService.signInResult = .success(expectedUser)
//        mockAuthService.checkEmailSignInStatusResult = true
//
//        // When
//        viewModel.signIn(email: MockConstants.testEmail, password: MockConstants.testPassword)
//
//        // Then
//        XCTAssertEqual(viewModel.user?.email, expectedUser.email)
//        XCTAssertTrue(mockAuthService.checkEmailSignInStatusResult)
//    }
//
//    func testSignInWrongPassword() {
//        // Given
//        mockAuthService.signInResult = .failure(AuthErrorCode.wrongPassword)
//
//        // When
//        viewModel.signIn(email: MockConstants.testEmail, password: MockConstants.testPassword)
//
//        // Then
//        XCTAssertEqual(viewModel.errorMessage, "Invalid email or password")
//    }
//
//    func testSignInEmailNotVerified() {
//        // Given
//        mockAuthService.signInResult = .failure(AuthErrorCode.emailNotVerified)
//
//        // When
//        viewModel.signIn(email: MockConstants.testEmail, password: MockConstants.testPassword)
//
//        // Then
//        XCTAssertEqual(viewModel.errorMessage, "Email not verified. Please check your email for a verification link.")
//    }
//
//    func testSignInFailure() {
//        // Given
//        mockAuthService.signInResult = .failure(NSError(domain: "test", code: 500, userInfo: nil))
//
//        // When
//        viewModel.signIn(email: MockConstants.testEmail, password: MockConstants.testPassword)
//
//        // Then
//        XCTAssertEqual(viewModel.errorMessage, "An error occurred. Please try again later.")
//    }
//
//    // Add more test cases as needed for other scenarios like checkEmailSignInStatus, fetchCustomerID, etc.
//}
//
