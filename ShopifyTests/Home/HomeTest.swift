//
//  HomeTest.swift
//  ShopifyTests
//
//  Created by Haneen Medhat on 25/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = HomeViewModel()
    }

    func testGetBrandsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Get brands success")
        let brandsResponse = CollectionResponse(smart_collections: [SmartCollection]())
        
        // When
        networkServiceMock.result = .success(brandsResponse)
        viewModel.getBrands()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.1) {
            XCTAssertNotNil(self.viewModel.brands)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6.0)
    }
    

    func testGetCouponsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Get coupons success")
        let couponsResponse = PriceRulesResponse(price_rules: [PriceRules]())

        // When
        networkServiceMock.result = .success(couponsResponse)
        viewModel.getCoupons()

        // Then
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.1) {
            XCTAssertNotNil(self.viewModel.coupons)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }



    func testGetDiscountCodeSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Get discount code success")
        let discountResponse = DiscountResponse(discount_codes: [Discount]())

        // When
        networkServiceMock.result = .success(discountResponse)
        viewModel.getDiscountCode(id: 1) { discountCode in
            XCTAssertNotNil(discountCode)
            expectation.fulfill()
        }
    }

    func testGetDiscountCodeFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Get discount code failure")
        let error = NSError(domain: "Error", code: 0, userInfo: nil)

        // When
        networkServiceMock.result = .failure(error)
        viewModel.getDiscountCode(id: 1) { discountCode in
            XCTAssertNil(discountCode)
            expectation.fulfill()
        }
    }

}




