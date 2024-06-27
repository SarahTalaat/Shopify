////
////  SignInViewModelNew.swift
////  ShopifyTests
////
////  Created by Sara Talat on 26/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//
//class MockNetworkService: NetworkServiceAuthenticationProtocol {
//    func requestFunction<T>(urlString: String, method: HTTPMethod, model: [String : Any], completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
//        // Mock implementation for requestFunction
//        let response = OneDraftOrderResponse(draftOrder: MockDraftOrderResponse.mockDraftOrderDetails)
//        completion(.success(response as! T)) // Simulate success
//    }
//}
//
//
//class SignInViewModelTests: XCTestCase {
//
//    var viewModel: SignInViewModel!
//
//    override func setUp() {
//        super.setUp()
//        let authService = MockAuthService()
//        let networkService = MockNetworkService()
//        viewModel = SignInViewModel(authServiceProtocol: authService as AuthServiceProtocol, networkServiceAuthenticationProtocol: networkService as NetworkServiceAuthenticationProtocol)
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        super.tearDown()
//    }
//
//    func testSignInSuccess() {
//        // Given
//        let expectation = XCTestExpectation(description: "Sign in should succeed")
//
//        // When
//        viewModel.signIn(email: "test@example.com", password: "password")
//
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            // Assert user model is set
//            XCTAssertNotNil(self.viewModel.user)
//
//            // Assert customer ID and other shared data are set
//            XCTAssertEqual(self.viewModel.customerID, "mock_cid")
//            XCTAssertEqual(SharedDataRepository.instance.customerEmail, "test@example.com")
//            XCTAssertEqual(SharedDataRepository.instance.shoppingCartId, "mock_sid")
//
//            // Fulfill expectation
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 3.0)
//    }
//
//    func testSignInFailure_wrongPassword() {
//        // Given
//        let expectation = XCTestExpectation(description: "Sign in should fail due to wrong password")
//
//        // Mocking wrong password error
//        viewModel.authServiceProtocol.signIn(email: "test@example.com", password: "wrongpassword") { result in
//            switch result {
//            case .success(_):
//                XCTFail("Expected failure for wrong password")
//            case .failure(let error):
//                guard let authError = error as? AuthErrorCode else {
//                    XCTFail("Expected AuthErrorCode.wrongPassword")
//                    return
//                }
//                XCTAssertEqual(authError, .wrongPassword)
//                expectation.fulfill()
//            }
//        }
//
//        // When
//        viewModel.signIn(email: "test@example.com", password: "wrongpassword")
//
//        wait(for: [expectation], timeout: 3.0)
//    }
//
//    func testSignInFailure_userNotFound() {
//        // Given
//        let expectation = XCTestExpectation(description: "Sign in should fail due to user not found")
//
//        // Mocking user not found error
//        viewModel.authServiceProtocol.signIn(email: "nonexistent@example.com", password: "password") { result in
//            switch result {
//            case .success(_):
//                XCTFail("Expected failure for user not found")
//            case .failure(let error):
//                guard let authError = error as? AuthErrorCode else {
//                    XCTFail("Expected AuthErrorCode.userNotFound")
//                    return
//                }
//                XCTAssertEqual(authError, .userNotFound)
//                expectation.fulfill()
//            }
//        }
//
//        // When
//        viewModel.signIn(email: "nonexistent@example.com", password: "password")
//
//        wait(for: [expectation], timeout: 3.0)
//    }
//
//    func testSignInFailure_emailNotVerified() {
//        // Given
//        let expectation = XCTestExpectation(description: "Sign in should fail due to email not verified")
//
//        // Mocking email not verified error
//        viewModel.authServiceProtocol.signIn(email: "unverified@example.com", password: "password") { result in
//            switch result {
//            case .success(_):
//                XCTFail("Expected failure for email not verified")
//            case .failure(let error):
//                guard let authError = error as? AuthErrorCode else {
//                    XCTFail("Expected AuthErrorCode.emailNotVerified")
//                    return
//                }
//                XCTAssertEqual(authError, .emailNotVerified)
//                expectation.fulfill()
//            }
//        }
//
//        // When
//        viewModel.signIn(email: "unverified@example.com", password: "password")
//
//        wait(for: [expectation], timeout: 3.0)
//    }
//}
//struct MockDraftOrderResponse {
//    static var mockResponse: OneDraftOrderResponse {
//        return OneDraftOrderResponse(draftOrder: mockDraftOrderDetails)
//    }
//
//    static var mockDraftOrderDetails: OneDraftOrderResponseDetails {
//        return OneDraftOrderResponseDetails(
//            id: 123456,
//            note: "Mock note",
//            email: "mock@example.com",
//            taxesIncluded: true,
//            currency: "USD",
//            invoiceSentAt: "2024-06-26T12:00:00Z",
//            createdAt: "2024-06-26T10:00:00Z",
//            updatedAt: "2024-06-26T11:00:00Z",
//            taxExempt: false,
//            completedAt: nil,
//            name: "Mock Draft Order",
//            status: "open",
//            lineItems: [mockLineItem],
//            shippingAddress: "Mock Shipping Address",
//            billingAddress: "Mock Billing Address",
//            invoiceUrl: "https://example.com/invoice",
//            appliedDiscount: "Mock Discount",
//            orderId: 987654, // Mock Order ID
//            shippingLine: "Standard Shipping",
//            taxLines: [mockTaxLine],
//            tags: "Mock Tag",
//            noteAttributes: ["Mock Attribute"],
//            totalPrice: "100.00",
//            subtotalPrice: "90.00",
//            totalTax: "10.00",
//            paymentTerms: "Net 30",
//            adminGraphqlApiId: "mock_admin_id"
//        )
//    }
//
//    static var mockLineItem: LineItem {
//        return LineItem(
//            id: 234567, // Mock ID
//            variantId: 345678, // Mock Variant ID
//            productId: 456789, // Mock Product ID
//            title: "Mock Product",
//            variantTitle: "Mock Variant",
//            sku: "MOCK123",
//            vendor: "Mock Vendor",
//            quantity: 1,
//            requiresShipping: true,
//            taxable: true,
//            giftCard: false,
//            fulfillmentService: "Mock Service",
//            grams: 500,
//            taxLines: [mockTaxLine],
//            appliedDiscount: "Mock Discount",
//            name: "Mock Product Name",
//            properties: ["Mock Property"],
//            custom: false,
//            price: "50.00",
//            adminGraphqlApiId: "mock_admin_id"
//        )
//    }
//
//    static var mockTaxLine: TaxLine {
//        return TaxLine(
//            rate: 0.08,
//            title: "Mock Tax",
//            price: "5.00"
//        )
//    }
//}
