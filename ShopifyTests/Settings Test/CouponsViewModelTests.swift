//
//  CouponsViewModelTests.swift
//  ShopifyTests
//
//  Created by Marim Mohamed Mohamed Yacout on 26/06/2024.
//

import Foundation
import XCTest
import XCTest
@testable import Shopify

class CouponsViewModelTests: XCTestCase {

    var viewModel: CouponsViewModel!

    override func setUpWithError() throws {
        viewModel = CouponsViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testValidateCoupon() {
           let validCoupon1 = "SUMMERSALE20OFF"
           let validCoupon2 = "T7NWDJK3C11Q"
           let invalidCoupon = "INVALIDCOUPON"

           viewModel.validateCoupon(validCoupon1) { discount in
               XCTAssertEqual(discount, 20.0)
           }

           viewModel.validateCoupon(validCoupon2) { discount in
               XCTAssertEqual(discount, 10.0)
           }

           viewModel.validateCoupon(invalidCoupon) { discount in
               XCTAssertNil(discount)
           }
       }

       func testUpdateTotals() {
           let discountAmount = 20.0
           let currency = "USD"
           
           viewModel.exchangeRates = [currency: 1.0]
           let result = viewModel.updateTotals(with: discountAmount, in: currency)
           
           XCTAssertEqual(result.discount, "20.00 USD")
           XCTAssertEqual(result.grandTotal, "80.00 USD")
       }

       func testSaveAndCheckCoupon() {
           let customerId = "customer1"
           let couponCode = "SUMMERSALE20OFF"
           
           viewModel.saveCouponCode(couponCode, for: customerId)
           
           let isUsed = viewModel.isCouponUsed(couponCode, by: customerId)
           XCTAssertTrue(isUsed)
           
           let anotherCoupon = "T7NWDJK3C11Q"
           let isAnotherCouponUsed = viewModel.isCouponUsed(anotherCoupon, by: customerId)
           XCTAssertFalse(isAnotherCouponUsed)
       }
}
