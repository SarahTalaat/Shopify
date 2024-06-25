////
////  AddressViewModelTests.swift
////  ShopifyTests
////
////  Created by Marim Mohamed Mohamed Yacout on 25/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//class AddressViewModelTests: XCTestCase {
//    var viewModel: AddressViewModel!
//    var networkService: MockNetworkService!
//
//    override func setUp() {
//        super.setUp()
//        networkService = MockNetworkService()
//        viewModel = AddressViewModel()
//        viewModel.networkService = networkService
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
//        let expectation = self.expectation(description: "Fetch addresses success")
//        networkService.result = .success(AddressListResponse(addresses: [Address(id: 1, first_name: "John", address1: "123 Street", city: "Cairo", country: "Egypt", zip: "12345", default: true)]))
//        viewModel.onAddressesUpdated = {
//            expectation.fulfill()
//        }
//
//        // When
//        viewModel.fetchAddresses()
//
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(self.viewModel.addresses.count, 1)
//            XCTAssertEqual(self.viewModel.addresses.first?.first_name, "John")
//        }
//    }
//
//    func testFetchAddressesFailure() {
//        // Given
//        let expectation = self.expectation(description: "Fetch addresses failure")
//        let error = NSError(domain: "test", code: -1, userInfo: nil)
//        networkService.result = .failure(error)
//        viewModel.onError = { receivedError in
//            XCTAssertEqual(receivedError as NSError, error)
//            expectation.fulfill()
//        }
//
//        // When
//        viewModel.fetchAddresses()
//
//        // Then
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    func testDeleteAddressSuccess() {
//        // Given
//        viewModel.addresses = [Address(id: 1, first_name: "John", address1: "123 Street", city: "Cairo", country: "Egypt", zip: "12345", default: true)]
//        let expectation = self.expectation(description: "Delete address success")
//        networkService.result = .success(EmptyResponse())
//
//        viewModel.onAddressesUpdated = {
//            expectation.fulfill()
//        }
//
//        // When
//        viewModel.deleteAddress(at: IndexPath(row: 0, section: 0))
//
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertTrue(self.viewModel.addresses.isEmpty)
//        }
//    }
//
//    func testDeleteAddressFailure() {
//        // Given
//        viewModel.addresses = [Address(id: 1, first_name: "John", address1: "123 Street", city: "Cairo", country: "Egypt", zip: "12345", default: true)]
//        let expectation = self.expectation(description: "Delete address failure")
//        let error = NSError(domain: "test", code: -1, userInfo: nil)
//        networkService.result = .failure(error)
//
//        viewModel.onError = { receivedError in
//            XCTAssertEqual(receivedError as NSError, error)
//            expectation.fulfill()
//        }
//
//        // When
//        viewModel.deleteAddress(at: IndexPath(row: 0, section: 0))
//
//        // Then
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    func testSetDefaultAddressSuccess() {
//        // Given
//        viewModel.addresses = [
//            Address(id: 1, first_name: "John", address1: "123 Street", city: "Cairo", country: "Egypt", zip: "12345", default: false),
//            Address(id: 2, first_name: "Jane", address1: "456 Avenue", city: "Alexandria", country: "Egypt", zip: "67890", default: true)
//        ]
//        let expectation = self.expectation(description: "Set default address success")
//        networkService.result = .success(Data())
//
//        viewModel.onAddressesUpdated = {
//            expectation.fulfill()
//        }
//
//        // When
//        viewModel.setDefaultAddress(at: IndexPath(row: 0, section: 0))
//
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(self.viewModel.selectedDefaultAddressId, 1)
//            XCTAssertTrue(self.viewModel.addresses[0].default ?? false)
//            XCTAssertFalse(self.viewModel.addresses[1].default ?? true)
//        }
//    }
//
//    func testSetDefaultAddressFailure() {
//        // Given
//        viewModel.addresses = [
//            Address(id: 1, first_name: "John", address1: "123 Street", city: "Cairo", country: "Egypt", zip: "12345", default: false)
//        ]
//        let expectation = self.expectation(description: "Set default address failure")
//        let error = NSError(domain: "test", code: -1, userInfo: nil)
//        networkService.result = .failure(error)
//
//        viewModel.onError = { receivedError in
//            XCTAssertEqual(receivedError as NSError, error)
//            expectation.fulfill()
//        }
//
//        // When
//        viewModel.setDefaultAddress(at: IndexPath(row: 0, section: 0))
//
//        // Then
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//}
//
