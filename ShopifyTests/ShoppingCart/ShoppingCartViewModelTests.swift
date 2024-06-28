////
////  ShoppingCartViewModelTests.swift
////  ShopifyTests
////
////  Created by Marim Mohamed Mohamed Yacout on 28/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//class ShoppingCartViewModelTests: XCTestCase {
//    var viewModel: ShoppingCartViewModel!
//    var networkService: NetworkServiceMock!
//
//    override func setUp() {
//        super.setUp()
//        networkService = NetworkServiceMock()
//        viewModel = ShoppingCartViewModel()
//        viewModel.networkService = networkService
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        networkService = nil
//        super.tearDown()
//    }
//
//    func testFetchDraftOrdersSuccess() {
//        // Given
//        let mockResponse = OneDraftOrderResponseDetails(/* provide necessary mock data */)
//        networkService.result = .success(mockResponse)
//
//        // When
//        let expectation = self.expectation(description: "Success")
//        viewModel.onDraftOrderUpdated = {
//            expectation.fulfill()
//        }
//        viewModel.fetchDraftOrders()
//
//        // Then
//        waitForExpectations(timeout: 5.0, handler: nil)
//        XCTAssertNotNil(viewModel.draftOrder, "Draft order should not be nil after successful fetch")
//        // Add more assertions based on your mock response
//    }
//
//    func testFetchDraftOrdersFailure() {
//        // Given
//        networkService.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))
//
//        // When
//        let expectation = self.expectation(description: "Failure")
//        viewModel.onError = { error in
//            XCTAssertNotNil(error, "Error should not be nil on failure")
//            expectation.fulfill()
//        }
//        viewModel.fetchDraftOrders()
//
//        // Then
//        waitForExpectations(timeout: 5.0, handler: nil)
//        // Add more assertions based on expected error handling behavior
//    }
//
//    func testIncrementQuantitySuccess() {
//        // Given
//        let mockProductResponse = OneProductResponse(/* provide necessary mock data */)
//        networkService.result = .success(mockProductResponse)
//
//        // When
//        viewModel.incrementQuantity(at: 0)
//
//        // Then
//        // Add assertions for success case
//    }
//
//    func testIncrementQuantityFailure() {
//        // Given
//        networkService.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))
//
//        // When
//        viewModel.onAlertMessage = { message in
//            XCTAssertEqual(message, "Failed to fetch product details")
//        }
//        viewModel.incrementQuantity(at: 0)
//
//        // Then
//        // Add assertions for failure case
//    }
//
//    func testDecrementQuantity() {
//        // Given
//        let lineItem = LineItem(/* provide necessary mock data */)
//        viewModel.displayedLineItems = [lineItem]
//        viewModel.draftOrder = OneDraftOrderResponseDetails(/* provide necessary mock data */)
//
//        // When
//        viewModel.decrementQuantity(at: 0)
//
//        // Then
//        XCTAssertEqual(viewModel.displayedLineItems[0].quantity, lineItem.quantity - 1, "Quantity should decrement by 1")
//    }
//
//    func testDeleteItem() {
//        // Given
//        let lineItem = LineItem(id: 1, variantId: 123, productId: 456, title: "Test Product", price: "10.00", quantity: 2)
//        let draftOrder = OneDraftOrderResponseDetails(/* provide necessary mock data */)
//        viewModel.displayedLineItems = [lineItem]
//        viewModel.draftOrder = draftOrder
//
//        // When
//        viewModel.deleteItem(at: 0)
//
//        // Then
//        XCTAssertEqual(viewModel.displayedLineItems.count, 0, "Item should be deleted from displayedLineItems")
//        XCTAssertEqual(viewModel.draftOrder?.draftOrder?.lineItems.count, draftOrder.draftOrder?.lineItems.count ?? 0 - 1, "Item should be deleted from draft order lineItems")
//    }
//
//    func testUpdateTotalAmount() {
//        // Given
//        let lineItem1 = LineItem(id: 1, variantId: 123, productId: 456, title: "Test Product 1", price: "10.00", quantity: 2)
//        let lineItem2 = LineItem(id: 2, variantId: 124, productId: 457, title: "Test Product 2", price: "15.00", quantity: 3)
//        viewModel.displayedLineItems = [lineItem1, lineItem2]
//
//        // When
//        viewModel.updateTotalAmount()
//
//        // Then
//        XCTAssertEqual(viewModel.totalAmount, "70.00", "Total amount should be calculated correctly based on displayed line items")
//    }
//
//    func testUpdateLineItem() {
//        // Given
//        let lineItem = LineItem(id: 1, variantId: 123, productId: 456, title: "Test Product", price: "10.00", quantity: 2)
//        viewModel.displayedLineItems = [lineItem]
//        viewModel.draftOrder = OneDraftOrderResponseDetails(/* provide necessary mock data */)
//
//        // When
//        let updatedLineItem = LineItem(id: 1, variantId: 123, productId: 456, title: "Test Product", price: "10.00", quantity: 3)
//        viewModel.updateLineItem(at: 0, with: updatedLineItem)
//
//        // Then
//        XCTAssertEqual(viewModel.displayedLineItems[0].quantity, updatedLineItem.quantity, "Quantity of line item should be updated")
//        XCTAssertEqual(viewModel.draftOrder?.draftOrder?.lineItems[0].quantity, updatedLineItem.quantity, "Quantity of line item in draft order should be updated")
//    }
//
//
//}
