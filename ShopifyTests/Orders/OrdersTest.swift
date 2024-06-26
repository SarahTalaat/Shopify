//
//  OrdersTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 25/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class OrdersViewModelTests: XCTestCase {
    
    var viewModel: OrdersViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = OrdersViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    func testGetOrdersSuccess() {
        // Given
        let expectation = self.expectation(description: "Orders fetch")
        var expectationFulfilled = false
        
        // Set up SharedDataRepository
        SharedDataRepository.instance.customerEmail = "haneenmtwll@gmail.com"
        
        // When
        viewModel.bindAllOrders = {
            print("bindAllOrders called")
            // Then
            if !expectationFulfilled {
                XCTAssertFalse(self.viewModel.orders.isEmpty, "Orders should not be empty")
                expectation.fulfill()
                expectationFulfilled = true
            }
        }
        
        // Call getOrders
        print("Calling getOrders")
        viewModel.getOrders()
        
        // Wait for expectation to be fulfilled or timeout
        waitForExpectations(timeout: 15) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
}
