//
//  NewAddressViewModelTest.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 28/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class NewAddressViewModelTest: XCTestCase {
    var viewModel: NewAddressViewModel!
    var networkService: CustomNetworkServiceMock! // Assuming CustomNetworkServiceMock conforms to NetworkServiceAuthenticationProtocol
    
    override func setUp() {
        super.setUp()
        networkService = CustomNetworkServiceMock()
        viewModel = NewAddressViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        networkService = nil
        super.tearDown()
    }
    
    func testIsAddressValid() {
        // Given
        viewModel.fullName = "Marim"
        viewModel.newAddress = "123 Street"
        viewModel.city = "Alex"
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
    
//    func testPostNewAddressSuccess() {
//        // Given
//        viewModel.fullName = "Marim"
//        viewModel.newAddress = "123 Street"
//        viewModel.city = "Alex"
//        viewModel.state = "Egypt"
//        viewModel.zipCode = "12345"
//        viewModel.customerId = "123"
//        
//        // Mock successful response
//        let mockAddress = Address(id: nil, first_name: "Marim", address1: "123 Street", city: "Alex", country: "Egypt", zip: "12345", `default`: false)
//        let mockResponse = AddressResponse(customer_address: mockAddress)
//        
//        do {
//            let data = try JSONEncoder().encode(mockResponse)
//            networkService.result = .success(data)
//        } catch {
//            XCTFail("Failed to encode mock response: \(error)")
//        }
//        
//        let expectation = self.expectation(description: "Success")
//        
//        // When
//        viewModel.postNewAddress { result in
//            switch result {
//            case .success(let address):
//                XCTAssertEqual(address.first_name, "Marim")
//                XCTAssertEqual(address.city, "Alex")
//                XCTAssertEqual(address.country, "Egypt")
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Expected success but got \(error) instead")
//            }
//        }
//        
//        // Then
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
    
    func testPostNewAddressFailure() {
        // Given
        viewModel.fullName = "Marim"
        viewModel.newAddress = "123 Street"
        viewModel.city = "Alex"
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
