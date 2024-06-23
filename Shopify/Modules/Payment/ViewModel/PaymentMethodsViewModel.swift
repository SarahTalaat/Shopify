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
    private var invoice:Invoice?
    private var invoiceResponse : InvoiceResponse?
    private var draftOrderId : Int?

    var defCurrency : String = "EGP"
     var totalAmount: String?
    private var viewModel = ShoppingCartViewModel()
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
    }
    func formatPriceWithCurrency(price: String) -> String {
            // Add a currency symbol and ensure the price is formatted correctly
            guard let amount = Double(price) else { return "$0.00" }
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
        }

        func updatePaymentSummaryItems(totalAmount: String) {
            // Update the payment summary items with the correct total amount
            // Here you would implement the logic to update the payment summary in your view model
            print("Updating payment summary items with total amount: \(totalAmount)")
            
            // Example logic (this will vary depending on your actual application structure)
            // Assuming you have a summary items list that needs to be updated:
            // self.paymentSummaryItems["total"] = totalAmount
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
            order_number: nil,
            created_at: nil,
            currency: defCurrency,
            email: email,
            total_price: nil,
            total_discounts: nil,
            total_tax: nil,
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
//    func formatPriceWithCurrency(price: Double) -> String {
//               let formatter = NumberFormatter()
//               formatter.numberStyle = .currency
//               formatter.currencyCode = "USD"
//               return formatter.string(from: NSNumber(value: price)) ?? ""
//           }
//
//                } else {
//                    print("Failed to post order.")
//                }
//            }
//        }
    

    func setupInvoice() {
        guard let email = SharedDataRepository.instance.customerEmail else {
            print("Customer email is nil")
            return
        }
        guard let customerName = SharedDataRepository.instance.customerName else {
            print("Customer name is nil")
            return
        }
        
        let subject = "Invoice for Your Recent Purchase "
        let customMessage = """
        Dear \(customerName),
        
        We have received your order and it is now being processed. Please find your invoice details below.
        Thank you for choosing Shoppingo!
        
        Best regards,
        Shoppingo Team
        """
        invoice = Invoice(
            to: email,
            from: "safiyafikry@gmail.com",
            subject: subject,
            custom_message: customMessage
        )
        invoiceResponse = InvoiceResponse(draft_order_invoice: invoice!)
    }
    
    
    func postInvoice(draftOrderId: String) {
        NetworkUtilities.postData(data: invoiceResponse, endpoint: "draft_orders/\(draftOrderId)/send_invoice.json") { success in
            if success {
                print("Invoice posted successfully!")
            } else {
                print("Invoice failed to post.")
            }
        }
    }
    
    func getDraftOrderID(email: String, completion: @escaping (String?) -> Void) {
        FirebaseAuthService().getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                print("kkk *Failed* to retrieve shopping cart ID: \(error.localizedDescription)")
                completion(nil)
            } else if let shoppingCartId = shoppingCartId {
                print("kkk *PD* Shopping cart ID found: \(shoppingCartId)")
                SharedDataRepository.instance.draftOrderId = shoppingCartId
                print("kkk *PD* Singleton draft id: \(SharedDataRepository.instance.draftOrderId)")
                completion(shoppingCartId)
            } else {
                print("kkk *PD* No shopping cart ID found for this user.")
                completion(nil)
            }
        }
    }
    
    func getUserDraftOrderId(completion: @escaping (String?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let email = SharedDataRepository.instance.customerEmail ?? "No email"
            self.getDraftOrderID(email: email) { draftOrderId in
                completion(draftOrderId)
            }
        }
    }
    
    func processInvoicePosting() {
       getUserDraftOrderId { draftOrderId in
                guard let draftOrderId = draftOrderId else {
                    print("Failed to get draft order ID.")
                    return
                }
                self.setupInvoice()
                self.postInvoice(draftOrderId: draftOrderId)
        }
    }

}
