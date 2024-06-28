//
//  AllProductsTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 25/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class AllProductsViewModelTests: XCTestCase {

    var viewModel: AllProductsViewModel!
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = AllProductsViewModel()
    }

    func testGetProductsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Get products success")
        let productResponse = ProductResponse(products: [Products]())

        // When
        networkServiceMock.result = .success(productResponse)
        viewModel.getProducts()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.products)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testFilterProducts() {
        // Given
        let expectation = XCTestExpectation(description: "Filter products")
        let products = [Products]()
        viewModel.products = products

        // When
        viewModel.filterProducts(by: "query")

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.filteredProducts)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}


