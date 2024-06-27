////
////  SettingsViewModelTests.swift
////  ShopifyTests
////
////  Created by Marim Mohamed Mohamed Yacout on 26/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//class SettingsViewModelTests: XCTestCase {
//    var viewModel: SettingsViewModel!
//    var mockNetworkService: MockNetworkService!
//
//    override func setUp() {
//        super.setUp()
//        mockNetworkService = MockNetworkService()
//        let dummyAuthService = DummyAuthService()
//        viewModel = SettingsViewModel(authService: dummyAuthService, networkService: mockNetworkService)
//   }
//
//   override func tearDown() {
//       viewModel = nil
//        mockNetworkService = nil
//        super.tearDown()
//    }
//    func testFetchDefaultAddress_WhenCustomerIdIsMissing_ThrowsError() {
//            // Given
//            SharedDataRepository.instance.customerId = nil
//
//            // When
//            let expectation = self.expectation(description: "Fetch default address error")
//            viewModel.fetchDefaultAddress { result in
//                switch result {
//                case .success:
//                    XCTFail("Expected error but got success instead")
//                case .failure(let error):
//                    XCTAssertEqual(error.localizedDescription, "Customer ID is missing")
//                    expectation.fulfill()
//                }
//            }
//
//            // Then
//            waitForExpectations(timeout: 5.0, handler: nil)
//        }
//
//        func testFetchDefaultAddress_WhenNetworkServiceFails_ThrowsError() {
//            // Given
//            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
//            mockNetworkService.result = .failure(error)
//
//            // When
//            let expectation = self.expectation(description: "Fetch default address error")
//            viewModel.fetchDefaultAddress { result in
//                switch result {
//                case .success:
//                    XCTFail("Expected error but got success instead")
//                case .failure(let error):
//                    XCTAssertEqual(error.localizedDescription, "Network error")
//                    expectation.fulfill()
//                }
//            }
//
//            // Then
//            waitForExpectations(timeout: 5.0, handler: nil)
//        }
//
//
//}
