//
//  CouponsViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
//

import Foundation
class CouponsViewModel {
    
    var network = NetworkServiceAuthentication.instance
    private(set) var discountCodes: [String] = []
    var exchangeRates: [String: Double] = [:]

    var staticSubTotal: Double = 100.00

    var subTotal: String = String(format: "%.2f", 100.00) {
        didSet {
            if let subTotalValue = Double(subTotal.replacingOccurrences(of: "", with: "")) {
                staticSubTotal = subTotalValue
            }
        }
    }

    func fetchExchangeRates() {
            
            network.requestFunction(urlString: APIConfig.usd.url2, method: .get, model: [:]){ (result: Result<ExchangeRatesResponse, Error>) in
                switch result {
                case .success(let response):
                    print("PD Exchange Rates Response\(response)")
                    self.exchangeRates = response.conversion_rates
                case .failure(let error):
                    print(error)
                }
              
            }
            
        }

    func getConvertedValue(for amount: Double, in currency: String) -> Double {
        let exchangeRate = exchangeRates[currency] ?? 1.0
        return amount * exchangeRate
    }

    func validateCoupon(_ couponCode: String, completion: @escaping (Double?) -> Void) {
        let discountAmount: Double? = {
            if couponCode == "SUMMERSALE20OFF" {
                return 20.0
            } else if couponCode == "T7NWDJK3C11Q" {
                return 10.0
            } else {
                return nil
            }
        }()
        completion(discountAmount)
    }

    func updateTotals(with discountAmount: Double, in currency: String) -> (discount: String, grandTotal: String) {
        let discountValue = staticSubTotal * (discountAmount / 100.0)
        let grandTotalValue = staticSubTotal - discountValue

        let convertedDiscount = getConvertedValue(for: discountValue, in: currency)
        let convertedGrandTotal = getConvertedValue(for: grandTotalValue, in: currency)

        return (String(format: "%.2f", convertedDiscount) + " \(currency)", String(format: "%.2f", convertedGrandTotal) + " \(currency)")
    }

    func saveCouponCode(_ couponCode: String, for customerId: String) {
        var usedCouponsDict = UserDefaults.standard.dictionary(forKey: "usedCoupons") as? [String: [String]] ?? [:]
        var usedCoupons = usedCouponsDict[customerId] ?? []
        usedCoupons.append(couponCode)
        usedCouponsDict[customerId] = usedCoupons
        UserDefaults.standard.set(usedCouponsDict, forKey: "usedCoupons")
    }

    func isCouponUsed(_ couponCode: String, by customerId: String) -> Bool {
        let usedCouponsDict = UserDefaults.standard.dictionary(forKey: "usedCoupons") as? [String: [String]] ?? [:]
        let usedCoupons = usedCouponsDict[customerId] ?? []
        return usedCoupons.contains(couponCode)
    }
}
