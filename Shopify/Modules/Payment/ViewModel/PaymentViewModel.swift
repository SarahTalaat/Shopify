//
//  PaymentViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 12/06/2024.
//

import Foundation
import PassKit

class PaymentViewModel: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    enum PaymentMethod {
        case cash
        case applePay
    }
    
    var selectedPaymentMethod: PaymentMethod?
    
    var paymentRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = UserDefaults.standard.string(forKey: "Currency") == "EGP" ? "EGP" : "USD"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "T-shirt", amount: 1200)]
        return request
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
    }
}
