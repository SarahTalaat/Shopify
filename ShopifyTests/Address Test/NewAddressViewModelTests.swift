//
//  NewAddressViewModelTests.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 25/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class NewAddressViewModelTests: XCTestCase {
    var viewModel: NewAddressViewModel!
    var networkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        viewModel = NewAddressViewModel(networkService: networkService)
    }
    
    override func tearDown() {
        viewModel = nil
        networkService = nil
        super.tearDown()
    }
    
    func testIsAddressValid() {
        // Given
        viewModel.fullName = "John Doe"
        viewModel.newAddress = "123 Street"
        viewModel.city = "Cairo"
        viewModel.state = "Egypt"
        viewModel.zipCode = "12345"
        
        // When
        let isValid = viewModel.isAddressValid()
        
        // Then
        XCTAssertTrue(isValid, "Address should be valid")
    }
    
    func testIsAddressInvalid() {
        // Given
        viewModel.fullName = ""
        viewModel.newAddress = "123 Street"
        viewModel.city = "Cairo"
        viewModel.state = "Egypt"
        viewModel.zipCode = "12345"
        
        // When
        let isValid = viewModel.isAddressValid()
        
        // Then
        XCTAssertFalse(isValid, "Address should be invalid due to empty fullName")
    }
    
    func testPostNewAddressSuccess() {
        // Given
        viewModel.fullName = "John Doe"
        viewModel.newAddress = "123 Street"
        viewModel.city = "Cairo"
        viewModel.state = "Egypt"
        viewModel.zipCode = "12345"
        viewModel.customerId = "123"
        
        let expectation = self.expectation(description: "Success")
        
        // When
        viewModel.postNewAddress { result in
            switch result {
            case .success(let address):
                XCTAssertEqual(address.first_name, "John Doe")
                XCTAssertEqual(address.city, "Cairo")
                XCTAssertEqual(address.country, "Egypt")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got \(error) instead")
            }
        }
        
        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testPostNewAddressFailure() {
        // Given
        viewModel.fullName = "John Doe"
        viewModel.newAddress = "123 Street"
        viewModel.city = "Cairo"
        viewModel.state = "Egypt"
        viewModel.zipCode = "12345"
        viewModel.customerId = "123"
        
        let expectation = self.expectation(description: "Failure")
        
        networkService.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))
        
        // When
        viewModel.postNewAddress { result in
            switch result {
            case .success(let address):
                XCTFail("Expected failure but got success with \(address) instead")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
