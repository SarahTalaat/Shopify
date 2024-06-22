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
    private var lineItem: LineItem?
    private var order: Orders?
    private var ordersSend: OrdersSend?
    var defCurrency : String = "EGP"
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
    
    
    
    
    
    func setupOrder(lineItem:[LineItem]) {
        
        if let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") {
            defCurrency = selectedCurrency
        } else {
            defCurrency = "USD"
        }
        
        guard let email = SharedDataRepository.instance.customerEmail else {
            print("Customer email is nil")
            return
        }
        
        let unwrappedLineItems = lineItem.map { lineItem in
            LineItem(
                id: lineItem.id,
                variantId: lineItem.variantId,
                productId: lineItem.productId,
                title: lineItem.title,
                variantTitle: lineItem.variantTitle ?? "",
                sku: lineItem.sku ?? "",
                vendor: lineItem.vendor ?? "",
                quantity: lineItem.quantity,
                requiresShipping: lineItem.requiresShipping ?? false,
                taxable: lineItem.taxable ?? false,
                giftCard: lineItem.giftCard ?? false,
                fulfillmentService: lineItem.fulfillmentService ?? "",
                grams: lineItem.grams ?? 0,
                taxLines: lineItem.taxLines ?? [],
                appliedDiscount: lineItem.appliedDiscount ?? "",
                name: lineItem.name ?? "",
                properties: lineItem.properties ?? [],
                custom: lineItem.custom ?? false,
                price: lineItem.price,
                adminGraphqlApiId: lineItem.adminGraphqlApiId ?? ""
            )
        }
        print(email)
        print(defCurrency)
        print(unwrappedLineItems)
        
        order = Orders(
            id: nil,
            created_at: nil,
            currency: defCurrency,
            email: email,
            total_price: nil,
            line_items: unwrappedLineItems
        )
        
        ordersSend = OrdersSend(order: order!)
    }
    
    func postOrder(completion: @escaping (Bool) -> Void) {
        guard let ordersSend = ordersSend else {
            print("Order is not set up correctly")
            completion(false)
            return
        }
        
        NetworkUtilities.postData(data: ordersSend, endpoint: "orders.json") { success in
            if success {
                print("Order posted successfully!")
                completion(true)
            } else {
                print("Failed to post order.")
                completion(false)
            }
        }
    }
    func formatPriceWithCurrency(price: Double) -> String {
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           formatter.currencyCode = "USD" 
           return formatter.string(from: NSNumber(value: price)) ?? ""
       }
}
