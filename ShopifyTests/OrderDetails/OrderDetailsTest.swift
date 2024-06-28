//
//  OrderDetailsTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 27/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class OrderDetailsViewModelTests: XCTestCase {

    var viewModel: OrderDetailsViewModel!
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = OrderDetailsViewModel()
    }

    func testGetOrderByIdSuccess() {
        // Given
        let orderSend = OrdersSend(order: Orders(id: 6148310073505, order_number: 1104, created_at: "2024-06-27T22:21:52-04:00", currency: "EGP", email: "eng.medhat57204@gmail.com", total_price:  "229.00", total_discounts: "0.00", total_tax:  "0.00", line_items: [], inventory_behaviour: "decrement_obeying_policy", subtotal_price :"229.00", total_outstanding: "261.06",current_total_discounts : "0.00"))
        networkServiceMock.result = .success(orderSend)

        // When
        viewModel.id = 1

        // Then
        XCTAssertNotNil(viewModel.orders)
    }

    func testGetOrderByIdFailure() {
        // Given
        let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch order"])
        networkServiceMock.result = .failure(error)

        // When
        viewModel.id = 1

        // Then
        XCTAssertTrue(viewModel.orders.isEmpty)

    }

    func testGetProductsSuccess() {
        // Given
        let variant = Variants(
            id: 44382096457889,
            product_id: 8048430874785,
            title:  "OS / black",
            price: "70.00",
            position: 1,
            inventory_policy: "deny",
            option1: "OS",
            option2: "black",
            inventory_item_id: 46483494568097,
            inventory_quantity: 13,
            requires_shipping: true
        )
        
        let image = Images(
            id:  39242426679457,
            product_id: 8048430874785,
            src:"https://cdn.shopify.com/s/files/1/0638/3252/2913/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1716922833"
        )
        
        let option = Options(
            id: 10231197401249,
            product_id:  8048430874785,
            name: "Size",
            values: ["OS"]
        )
        
        let product = Products(
            id: 8048430874785,
            title: "ADIDAS | CLASSIC BACKPACK",
            body_html: "This women's backpack has a glam look, thanks to a faux-leather build with an allover fur print. The front zip pocket keeps small things within reach, while an interior divider reins in potential chaos.",
            vendor: "ADIDAS",
            product_type: "ACCESSORIES",
            handle: "adidas-classic-backpack",
            status: "active",
            variants: [variant],
            images: [image],
            options: [option]
        )
        
        let singleProduct = SingleProduct(product: product)
        networkServiceMock.result = .success(singleProduct)

        // When
        viewModel.getProducts(productId: 1) { product in
            // Then
            XCTAssertNotNil(product)
            XCTAssertEqual(product?.id, 1)
        }
    }
    func testGetProductsFailure() {
        // Given
        let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch product"])
        networkServiceMock.result = .failure(error)

        // When
        viewModel.getProducts(productId: 1) { product in
            // Then
            XCTAssertTrue(self.viewModel.products.isEmpty)
        }
    }
}
