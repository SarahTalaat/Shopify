//
//  CategoryTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 26/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

    class CategoryViewModelTests: XCTestCase {
        
        var viewModel: CategoryViewModel!
        var networkServiceMock: NetworkServiceMock!
        
        override func setUp() {
            super.setUp()
            networkServiceMock = NetworkServiceMock()
            viewModel = CategoryViewModel()
        }
        
        override func tearDown() {
            viewModel = nil
            networkServiceMock = nil
            super.tearDown()
        }
        
        func testGetCategorySuccess() {
            // Given
            let expectation = XCTestExpectation(description: "Get category success")
            let image = ImageOf(id: 39242425172129, product_id: 8048430645409, src: "https://cdn.shopify.com/s/files/1/0638/3252/2913/files/7883dc186e15bf29dad696e1e989e914.jpg?v=1716922813")
            let product = Product(id: 8048430645409, title: "ADIDAS | KID'S STAN SMITH", body_html: "", vendor: "", product_type: "", image: image, status: "")
            let categoryResponse = CategoryResponse(products: [product])
            let data = try! JSONEncoder().encode(categoryResponse)
            
            // Mock network response
            networkServiceMock.result = .success(data)
            
            // When
            viewModel.getCategory(id: .kids)
            
            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNotNil(self.viewModel.category)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 7.0)
        }
        
        func testGetCategoryFailure() {
            // Given
            let expectation = XCTestExpectation(description: "Get category failure")
            let error = NSError(domain: "Error", code: 0, userInfo: nil)
            
            // Mock network response
            networkServiceMock.result = .failure(error)
            
            // When
            viewModel.getCategory(id: .women)
            
            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertTrue(self.viewModel.category.isEmpty)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        }
        
        func testFilterBySubCategory() {
            // Given
            let image = ImageOf(id: 1, product_id: 1, src: "image_url")
            let product1 = Product(id: 1, title: "Product 1", body_html: "", vendor: "", product_type: "SHOES", image: image, status: "")
            let product2 = Product(id: 2, title: "Product 2", body_html: "", vendor: "", product_type: "T-SHIRTS", image: image, status: "")
            viewModel.subCategory = [product1, product2]
            
            // When
            viewModel.filterBySubCategory(subcategory: .shoes)
            
            // Then
            XCTAssertEqual(viewModel.category.count, 1)
            XCTAssertEqual(viewModel.category.first?.product_type, "SHOES")
        }
        
        func testApplyFilters() {
            // Given
            let image = ImageOf(id: 1, product_id: 1, src: "image_url")
            let product1 = Product(id: 1, title: "Product 1", body_html: "", vendor: "", product_type: "", image: image, status: "")
            let product2 = Product(id: 2, title: "Product 2", body_html: "", vendor: "", product_type: "", image: image, status: "")
            viewModel.category = [product1, product2]
            viewModel.searchQuery = "Product 1"
            
            // When
            viewModel.applyFilters()
            
            // Then
            XCTAssertEqual(viewModel.filteredProducts.count, 1)
            XCTAssertEqual(viewModel.filteredProducts.first?.title, "Product 1")
        }
    }

