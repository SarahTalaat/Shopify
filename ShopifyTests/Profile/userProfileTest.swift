//
//  userProfileTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 27/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class UserProfileViewModelTests: XCTestCase {

    var viewModel: UserProfileViewModel!
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = UserProfileViewModel()
    }

    func testGetOrdersSuccess() {
        // Given
        let ordersResponse = OrdersResponse(orders: [Orders(id: 6148310073505, order_number: 1104, created_at: "2024-06-27T22:21:52-04:00", currency: "EGP", email: "eng.medhat57204@gmail.com", total_price:  "229.00", total_discounts: "0.00", total_tax:  "0.00", line_items: [], inventory_behaviour: "decrement_obeying_policy",subtotal_price :"229.00", total_outstanding: "261.06",current_total_discounts : "0.00")])
        networkServiceMock.result = .success(ordersResponse)

        // When
        viewModel.getOrders()

        // Then
        XCTAssertNotNil(viewModel.orders)
    }

    func testGetOrdersFailure() {
        // Given
        let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch orders"])
        networkServiceMock.result = .failure(error)

        // When
        viewModel.getOrders()

        // Then
        XCTAssertTrue(viewModel.orders.isEmpty)
    }
    
}
