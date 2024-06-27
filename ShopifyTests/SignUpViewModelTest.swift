////
////  SignUpViewModelTest.swift
////  ShopifyTests
////
////  Created by Sara Talat on 27/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//import XCTest
//
//class SignUpViewModelTests: XCTestCase {
//
//    var viewModel: SignUpViewModel!
//    var firebaseAuthService: FirebaseAuthServiceMock2!
//    var networkServiceAuthentication: NetworkServiceMock!
//
//    override func setUp() {
//        super.setUp()
//        viewModel = SignUpViewModel()
//        firebaseAuthService = FirebaseAuthServiceMock2()
//        networkServiceAuthentication = NetworkServiceMock()
//        FirebaseAuthService.instance = firebaseAuthService
//        NetworkServiceAuthentication.instance = networkServiceAuthentication
//    }
//
//    func testSignUpSuccess() {
//        // Given
//        let email = "test@example.com"
//        let password = "Password123"
//        let firstName = "John"
//
//        // When
//        viewModel.signUp(email: email, password: password, firstName: firstName)
//
//        // Then
//        XCTAssertNotNil(viewModel.user)
//    }
//
//    func testSignUpEmailTaken() {
//        // Given
//        let email = "test@example.com"
//        let password = "Password123"
//        let firstName = "John"
//        firebaseAuthService.isEmailTakenResult = true
//
//        // When
//        viewModel.signUp(email: email, password: password, firstName: firstName)
//
//        // Then
//        XCTAssertNotNil(viewModel.errorMessage)
//        XCTAssertEqual(viewModel.errorMessage, "This email is already in use. Please choose a different email address.")
//    }
//
//    func testSignUpInvalidEmailFormat() {
//        // Given
//        let email = "invalidEmail"
//        let password = "Password123"
//        let firstName = "John"
//
//        // When
//        viewModel.signUp(email: email, password: password, firstName: firstName)
//
//        // Then
//        XCTAssertNotNil(viewModel.errorMessage)
//        XCTAssertEqual(viewModel.errorMessage, "Invalid email format. Please enter a valid email address.")
//    }
//
//    func testSignUpPasswordErrors() {
//        // Given
//        let email = "test@example.com"
//        let password = "password"
//        let firstName = "John"
//
//        // When
//        viewModel.signUp(email: email, password: password, firstName: firstName)
//
//        // Then
//        XCTAssertNotNil(viewModel.errorMessage)
//        XCTAssertGreaterThan(viewModel.errorMessage?.count ?? 0, 0)
//    }
//
//    func testValidatePassword() {
//        // Given
//        let password = "Password123"
//
//        // When
//        let errors = viewModel.validatePassword(password)
//
//        // Then
//        XCTAssert(errors.isEmpty)
//    }
//
//    func testValidatePasswordLength() {
//        // Given
//        let password = "Pass"
//
//        // When
//        let errors = viewModel.validatePassword(password)
//
//        // Then
//        XCTAssertGreaterThan(errors.count, 0)
//    }
//
//    func testValidatePasswordUppercaseLetter() {
//        // Given
//        let password = "password123"
//
//        // When
//        let errors = viewModel.validatePassword(password)
//
//        // Then
//        XCTAssertGreaterThan(errors.count, 0)
//    }
//
//    func testValidatePasswordSpecialCharacter() {
//        // Given
//        let password = "Password123"
//
//        // When
//        let errors = viewModel.validatePassword(password)
//
//        // Then
//        XCTAssertGreaterThan(errors.count, 0)
//    }
//
//    func testValidatePasswordNumber() {
//        // Given
//        let password = "Passwordabc"
//
//        // When
//        let errors = viewModel.validatePassword(password)
//
//        // Then
//        XCTAssertGreaterThan(errors.count, 0)
//    }
//
//    func testPostNewCustomerSuccess() {
//        // Given
//        let urlString = "urlString"
//        let parameters: [String: Any] = [:]
//        let response = CustomerResponse(customer: Customer(id: 1))
//
//        // When
//        networkServiceAuthentication.postCustomerResult = .success(response)
//        viewModel.postNewCustomer(urlString: urlString, parameters: parameters, name: "John", email: "test@example.com")
//
//        // Then
//        XCTAssertTrue(firebaseAuthService.saveCustomerIdCalled)
//    }
//
//    func testPostNewCustomerFailure() {
//        // Given
//        let urlString = "urlString"
//        let parameters: [String: Any] = [:]
//        let error = NSError(domain: "Error", code: 0, userInfo: nil)
//
//        // When
//        networkServiceAuthentication.postCustomerResult = .failure(error)
//        viewModel.postNewCustomer(urlString: urlString, parameters: parameters, name: "John", email: "test@example.com")
//
//        // Then
//        XCTAssertNotNil(viewModel.errorMessage)
//        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
//    }
//
//    func testIsEmailFormatValid() {
//        // Given
//        let email = "test@example.com"
//
//        // When
//        let isValid = viewModel.isEmailFormatValid(email)
//
//        // Then
//        XCTAssertTrue(isValid)
//    }
//
//    func testIsEmailFormatInvalid() {
//        // Given
//        let email = "invalidEmail"
//
//        // When
//        let isValid = viewModel.isEmailFormatValid(email)
//
//        // Then
//        XCTAssertFalse(isValid)
//    }
//}
//
//class FirebaseAuthServiceMock3: FirebaseAuthService {
//
//    var isEmailTakenResult: Bool?
//    var signUpResult: Result<UserModel, Error>?
//   var saveCustomerIdCalled = false
//
//    override func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
//        if let isEmailTakenResult = isEmailTakenResult {
//            completion(isEmailTakenResult)
//        }
//    }
//
//    override func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        if let signUpResult = signUpResult {
//            completion(signUpResult)
//        }
//    }
//
//    override func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String, isSignedIn: String) {
//        saveCustomerIdCalled = true
//    }
//}
//
//class NetworkServiceAuthenticationMock3: NetworkServiceAuthentication {
//
//    var postCustomerResult: Result<CustomerResponse, Error>?
//
//    func requestFunction<T: Codable>(urlString: String, method: HTTPMethod, model: T?, completion: @escaping (Result<T, Error>) -> Void) {
//        if let postCustomerResult = postCustomerResult {
//            completion(postCustomerResult)
//        }
//    }
//}
//
//struct CustomerResponse: Codable {
//    let customer: Customer
//}
//
//struct Customer: Codable {
//    let id: Int
//}
