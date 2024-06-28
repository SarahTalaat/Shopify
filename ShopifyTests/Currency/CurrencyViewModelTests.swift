//
//  CurrencyViewModelTests.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 28/06/2024.
//

import Foundation
import XCTest
@testable import Shopify

class CurrencyViewModelTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!
    var mockExchangeRateApiService: ExchangeRateApiServiceMock!

    override func setUp() {
        super.setUp()
        mockExchangeRateApiService = ExchangeRateApiServiceMock()
        viewModel = CurrencyViewModel(exchangeRateApiService: mockExchangeRateApiService)
    }

//    func testFetchCurrenciesSuccess() {
//           // Prepare mock response
//           let mockResponse = ExchangeRatesResponse(base_code: "USD", conversion_rates: ["USD": 1.0, "EGP": 18.0])
//           mockExchangeRateApiService.mockResponse = .success(mockResponse)
//           
//           let expectation = self.expectation(description: "Fetch currencies success")
//           
//           viewModel.fetchCurrencies { [weak self] in
//               print("Currencies: \(self?.viewModel.currencies ?? [])")
//               print("Filtered currencies: \(self?.viewModel.filteredCurrencies ?? [])")
//               
//               if let currencies = self?.viewModel.currencies, currencies.count == 2,
//                  let filteredCurrencies = self?.viewModel.filteredCurrencies, filteredCurrencies.count == 2 {
//                   expectation.fulfill()
//               } else {
//                   XCTFail("Currencies or filtered currencies are not updated correctly")
//               }
//           }
//           
//           waitForExpectations(timeout: 10, handler: nil)  // Increased timeout
//       }
    
    

    func testSetDefaultCurrencyIfNeeded() {
        // Simulate no default currency set
        UserDefaults.standard.removeObject(forKey: "selectedCurrency_123")
        
        viewModel.setDefaultCurrencyIfNeeded(customerId: "123")
        
        XCTAssertEqual(UserDefaults.standard.string(forKey: "selectedCurrency_123"), "USD")
    }

    override func tearDown() {
        viewModel = nil
        mockExchangeRateApiService = nil
        super.tearDown()
    }
}
