//
//  ProductsTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 25/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class ProductViewModelTests: XCTestCase {
    
    var viewModel: ProductViewModel!
    var networkServiceMock: NetworkServiceMock!
    
    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = ProductViewModel()
    }
    
    func testGetProductsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Get products success")
        let product = Products(id: 8048430874785, title: "ADIDAS | CLASSIC BACKPACK", body_html: "", vendor: "", product_type: "", handle: "", status: "", variants: [], images: [], options: [])
        let productsResponse = ProductResponse(products: [product])
        
        // When
        networkServiceMock.result = .success(productsResponse)
        viewModel.getProducts()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.1) {
            XCTAssertNotNil(self.viewModel.products)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testApplyFilters() {
        // Given
        let variant1 = Variants(id: 1, product_id: 1, title: "Variant 1", price: "10.0", position: 1, inventory_policy: "policy", option1: "option1", option2: "option2", inventory_item_id: 1, inventory_quantity: 10, requires_shipping: true)
        let variant2 = Variants(id: 2, product_id: 2, title: "Variant 2", price: "20.0", position: 2, inventory_policy: "policy", option1: "option1", option2: "option2", inventory_item_id: 2, inventory_quantity: 20, requires_shipping: true)
        
        let image1 = Images(id: 1, product_id: 1, src: "image1.src")
        let image2 = Images(id: 2, product_id: 2, src: "image2.src")
        
        let option1 = Options(id: 1, product_id: 1, name: "Option 1", values: ["value1", "value2"])
        let option2 = Options(id: 2, product_id: 2, name: "Option 2", values: ["value1", "value2"])
        
        let product1 = Products(id: 1, title: "Product 1", body_html: "", vendor: "", product_type: "", handle: "", status: "", variants: [variant1], images: [image1], options: [option1])
        let product2 = Products(id: 2, title: "Product 2", body_html: "", vendor: "", product_type: "", handle: "", status: "", variants: [variant2], images: [image2], options: [option2])
        
        viewModel.products = [product1, product2]
        
        // When
        viewModel.currentFilters.price = 15.0
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
        XCTAssertEqual(viewModel.filteredProducts.first?.id, 1)
    }

}
