////
////  AddressViewModelTests.swift
////  ShopifyTests
////
////  Created by Marim Mohamed Mohamed Yacout on 28/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//class AddressViewModelTests: XCTestCase {
//    var viewModel: AddressViewModel!
//    var networkService: CustomNetworkServiceMock! 
//    override func setUp() {
//        super.setUp()
//        networkService = CustomNetworkServiceMock()
//        viewModel = AddressViewModel(networkService: networkService)
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        networkService = nil
//        super.tearDown()
//    }
//
//    func testFetchAddressesSuccess() {
//        // Given
//        let address = Address(id: 1, first_name: "Marim", address1: "123 Street", city: "Alex", country: "Egypt", zip: "12345", `default`: false)
//        let mockResponse = AddressResponse(customer_address: address)
//        networkService.result = .success(mockResponse)
//
//        // When
//        let expectation = self.expectation(description: "Success")
//        viewModel.onAddressesUpdated = {
//            expectation.fulfill()
//        }
//        viewModel.fetchAddresses()
//
//        // Then
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }
//
//    func testFetchAddressesFailure() {
//        // Given
//        networkService.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))
//
//        // When
//        let expectation = self.expectation(description: "Failure")
//        viewModel.onError = { error in
//            XCTAssertNotNil(error)
//            expectation.fulfill()
//        }
//        viewModel.fetchAddresses()
//
//        // Then
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testDeleteAddressFailure() {
//        // Given
//        networkService.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))
//        viewModel.addresses = [Address(id: 1, first_name: "Marim", address1: "123 Street", city: "Alex", country: "Egypt", zip: "12345", `default`: false)]
//
//        // When
//        let expectation = self.expectation(description: "Failure")
//        viewModel.onError = { error in
//            XCTAssertNotNil(error)
//            expectation.fulfill()
//        }
//        viewModel.deleteAddress(at: IndexPath(row: 0, section: 0))
//
//        // Then
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testSetDefaultAddressFailure() {
//        // Given
//        networkService.result = .failure(NSError(domain: "test", code: -1, userInfo: nil))
//        viewModel.addresses = [Address(id: 1, first_name: "Marim", address1: "123 Street", city: "Alex", country: "Egypt", zip: "12345", `default`: false)]
//
//        // When
//        let expectation = self.expectation(description: "Failure")
//        viewModel.onError = { error in
//            XCTAssertNotNil(error)
//            expectation.fulfill()
//        }
//        viewModel.setDefaultAddress(at: IndexPath(row: 0, section: 0))
//
//        // Then
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//}
