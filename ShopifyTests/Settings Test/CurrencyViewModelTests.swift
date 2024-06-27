////
////  CurrencyViewModelTests.swift
////  ShopifyTests
////
////  Created by Marim Mohamed Mohamed Yacout on 26/06/2024.
////
//
//import Foundation
//import XCTest
//@testable import Shopify
//
//class CurrencyViewModelTests: XCTestCase {
//    
//    var viewModel: CurrencyViewModel!
//    var mockNetworkService: MockNetworkService!
//    
//    override func setUp() {
//        super.setUp()
//        mockNetworkService = MockNetworkService()
//        viewModel = CurrencyViewModel(networkService: mockNetworkService)
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        mockNetworkService = nil
//        super.tearDown()
//    }
//    
//    func testFetchExchangeRatesSuccess() {
//        // Given
//        let mockResponse = ExchangeRatesResponse(conversion_rates: ["USD": 1.0, "EGP": 15.7, "EUR": 0.85])
//        mockNetworkService.result = .success(mockResponse)
//        
//        // When
//        let baseCode = "USD" // or whichever base code is appropriate for your test
//        viewModel.fetchExchangeRates(base_code: baseCode)
//        
//        // Then
//        XCTAssertFalse(viewModel.currencies.isEmpty)
//        XCTAssertFalse(viewModel.filteredCurrencies.isEmpty)
//        XCTAssertTrue(viewModel.currencies.contains("USD"))
//        XCTAssertTrue(viewModel.currencies.contains("EGP"))
//    }
//
//    
//    func testFetchExchangeRatesFailure() {
//        // Given
//        mockNetworkService.result = .failure(NSError(domain: "TestError", code: -1, userInfo: nil))
//        
//        // When
//        viewModel.fetchExchangeRates()
//        
//        // Then
//        XCTAssertTrue(viewModel.currencies.isEmpty)
//        XCTAssertTrue(viewModel.filteredCurrencies.isEmpty)
//    }
//    
//    func testSetDefaultCurrencyIfNeeded() {
//        // Given
//        let customerId = "testCustomer"
//        let defaultCurrencyKey = "selectedCurrency_\(customerId)"
//        UserDefaults.standard.removeObject(forKey: defaultCurrencyKey)
//        
//        // When
//        viewModel.setDefaultCurrencyIfNeeded(customerId: customerId)
//        
//        // Then
//        let selectedCurrency = UserDefaults.standard.string(forKey: defaultCurrencyKey)
//        XCTAssertEqual(selectedCurrency, "USD")
//    }
//}
