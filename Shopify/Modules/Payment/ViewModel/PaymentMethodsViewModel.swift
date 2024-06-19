//
//  PaymentMethodsViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
//

import Foundation
import PassKit

class PaymentMethodsViewModel: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    enum PaymentMethod {
        case cash
        case applePay
    }
    
    var selectedPaymentMethod: PaymentMethod?
    private var totalAmount: String?
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
    }
    func updatePaymentSummaryItems(totalAmount: String) {
        self.totalAmount = totalAmount
    }
    
    var paymentRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = UserDefaults.standard.string(forKey: "Currency") == "EGP" ? "EGP" : "USD"
        if let total = totalAmount {
            let amount = NSDecimalNumber(string: total)
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Total Order", amount: amount)]
        } else {
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "T-shirt", amount: 1200)]
        }
        return request
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
 
    private var lineItem: LineItem?
     private var order: Orders?
     private var ordersSend: OrdersSend?

    func setupOrder(lineItem:LineItem) {

         order = Orders(
             id: nil,
             confirmation_number: nil,
             confirmed: nil,
             created_at: nil,
             currency: "USD",
             email: nil,
             financial_status: nil,
             order_number: nil,
             source_name: nil,
             tags: nil,
             token: nil,
             total_discounts: nil,
             total_line_items_price: nil,
             total_price: nil,
             line_items: [lineItem]
         )

         ordersSend = OrdersSend(order: order!)
     }
     
     func postOrder() {
         guard let ordersSend = ordersSend else {
             print("Order is not set up correctly")
             return
         }
         
         NetworkUtilities.postData(data: ordersSend, endpoint: "orders.json") { success in
             if success {
                 print("Order posted successfully!")
             } else {
                 print("Failed to post order.")
             }
         }
     }
}
