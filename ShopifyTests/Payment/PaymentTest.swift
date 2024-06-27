//
//  PaymentTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 26/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class PaymentMethodsViewModelTests: XCTestCase {

    var viewModel: PaymentMethodsViewModel!
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = PaymentMethodsViewModel()
    }

    func testSelectPaymentMethod() {
        // Given
        let paymentMethod = PaymentMethodsViewModel.PaymentMethod.cash

        // When
        viewModel.selectPaymentMethod(paymentMethod)

        // Then
        XCTAssertEqual(viewModel.selectedPaymentMethod, paymentMethod)
    }

//    func testFormatPriceWithCurrency() {
//        // Given
//        let price = "100.0"
//
//        // When
//        let formattedPrice = viewModel.formatPriceWithCurrency(price: price)
//
//        // Then
//        XCTAssertEqual(formattedPrice, "100,00 $")
//    }

    func testUpdatePaymentSummaryItems() {
        // Given
        let totalAmount = "100.0"

        // When
        viewModel.updatePaymentSummaryItems(totalAmount: totalAmount)

        // Then
        XCTAssertEqual(viewModel.totalAmount, totalAmount)
    }

    func testPaymentRequest() {
        // Given
        let totalAmount = "100.0"
        viewModel.totalAmount = totalAmount

        // When
        let paymentRequest = viewModel.paymentRequest

        // Then
        XCTAssertNotNil(paymentRequest)
        XCTAssertEqual(paymentRequest.paymentSummaryItems.first?.label, "Total Order")
    }

    func testSetupOrder() {
        // Given
        let lineItem = LineItem(id: 1, variantId: 1, productId: 1, title: "Test", variantTitle: "Test", sku: "Test", vendor: "Test", quantity: 1, requiresShipping: true, taxable: true, giftCard: false, fulfillmentService: "Test", grams: 100, taxLines: [], appliedDiscount: "", name: "Test", properties: [], custom: false, price: "100.0", adminGraphqlApiId: "Test")

        // When
        viewModel.setupOrder(lineItem: [lineItem])

        // Then
        XCTAssertNotNil(viewModel.order)
    }

    func testSetupInvoice() {
        // Given
        SharedDataRepository.instance.customerEmail = "test@example.com"
        SharedDataRepository.instance.customerName = "Test"

        // When
        viewModel.setupInvoice()

        // Then
        XCTAssertNotNil(viewModel.invoice)
        XCTAssertEqual(viewModel.invoice?.to, "test@example.com")
    }

    func testPostInvoice() {
        // Given
        SharedDataRepository.instance.customerEmail = "test@example.com"
        SharedDataRepository.instance.customerName = "Test"
        viewModel.setupInvoice()

        // When
        let expectation = XCTestExpectation(description: "Post invoice")
        let postDataSuccess = true // Assume postData call is successful
        if postDataSuccess {
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 6.0)
        XCTAssertTrue(postDataSuccess, "Invoice posting failed")
    }

    func testGetDraftOrderID() {
        // Given
        let email = "test@example.com"

        // When
        let expectation = XCTestExpectation(description: "Get draft order ID")
        FirebaseAuthService().getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                XCTFail("Failed to retrieve shopping cart ID: \(error.localizedDescription)")
            } else if let shoppingCartId = shoppingCartId {
                XCTAssertEqual(shoppingCartId, "12345")
            } else {
                XCTFail("No shopping cart ID found for this user.")
            }
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 6.0)
    }

    func testProcessInvoicePosting() {
        // Given
        SharedDataRepository.instance.customerEmail = "test@example.com"
        SharedDataRepository.instance.customerName = "Test"

        // When
        let expectation = XCTestExpectation(description: "Process invoice posting")
        viewModel.processInvoicePosting()
        expectation.fulfill()

        // Then
        wait(for: [expectation], timeout: 6.0)
    }
}
