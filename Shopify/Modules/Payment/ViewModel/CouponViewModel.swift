//
//  CouponViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 12/06/2024.
//

import Foundation
class CouponViewModel {
    let staticSubTotal: Double = 100.00
    private(set) var discountCodes: [String] = []

    var subTotal: String {
        return String(format: "$%.2f", staticSubTotal)
    }

    func validateCoupon(_ couponCode: String, completion: @escaping (Double?) -> Void) {
        let discountAmount: Double? = {
            if couponCode == "SUMMERSALE20OFF" {
                return 20.0
            } else if couponCode == "SUMMERSALE10OFF" {
                return 10.0
            } else {
                return nil
            }
        }()
        completion(discountAmount)
    }

    func updateTotals(with discountAmount: Double) -> (discount: String, grandTotal: String) {
        let discountValue = staticSubTotal * (discountAmount / 100.0)
        let grandTotalValue = staticSubTotal - discountValue

        return (String(format: "$%.2f", discountValue), String(format: "$%.2f", grandTotalValue))
    }

    func saveCouponCode(_ couponCode: String) {
        var usedCoupons = UserDefaults.standard.array(forKey: "usedCoupons") as? [String] ?? []
        usedCoupons.append(couponCode)
        UserDefaults.standard.set(usedCoupons, forKey: "usedCoupons")
    }

    func isCouponUsed(_ couponCode: String) -> Bool {
        let usedCoupons = UserDefaults.standard.array(forKey: "usedCoupons") as? [String] ?? []
        return usedCoupons.contains(couponCode)
    }
}
