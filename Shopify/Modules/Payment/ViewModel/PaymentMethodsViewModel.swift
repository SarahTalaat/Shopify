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
    private let networkService = NetworkServiceAuthentication()
     var selectedPaymentMethod: PaymentMethod?
     var lineItem: LineItem?
     var order: Orders?
     var ordersSend: OrdersSend?
     var invoice: Invoice?
     var invoiceResponse: InvoiceResponse?
     var draftOrderId: Int?
     var defCurrency: String = "EGP"
     var totalAmount: String?
     var addresses: [Address] = []
     var viewModel = ShoppingCartViewModel()
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
    }
    
    func formatPriceWithCurrency(price: String) -> String {
        guard let amount = Double(price) else { return "$0.00" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    func updatePaymentSummaryItems(totalAmount: String) {
        print("Updating payment summary items with total amount: \(totalAmount)")
        self.totalAmount = totalAmount
    }
    
    func setTotalAmount(_ amount: String) {
        self.totalAmount = amount
    }

    var paymentRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = UserDefaults.standard.string(forKey: "Currency") == "EGP" ? "EGP" : "USD"
        
        if let totalAmount = totalAmount {
            let totalAmountString = totalAmount.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
            let amount = NSDecimalNumber(string: totalAmountString)
            if amount != NSDecimalNumber.notANumber {
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Total Order", amount: amount)]
            } else {
                let defaultAmount = NSDecimalNumber(string: "1200")
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "T-shirt", amount: defaultAmount)]
            }
        } else {
            let defaultAmount = NSDecimalNumber(string: "1200")
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "T-shirt", amount: defaultAmount)]
        }
        
        return request
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    
    func setupOrder(lineItem: [LineItem]) {
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
        print(totalAmount)
        order = Orders(
            id: nil,
            order_number: nil,
            created_at: nil,
            currency: defCurrency,
            email: email,
            total_price:totalAmount,
            total_discounts: nil,
            total_tax: nil,
            line_items: unwrappedLineItems,
            inventory_behaviour: "decrement_obeying_policy"
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

    func setupInvoice() {
        guard let email = SharedDataRepository.instance.customerEmail else {
            print("Customer email is nil")
            return
        }
        guard let customerName = SharedDataRepository.instance.customerName else {
            print("Customer name is nil")
            return
        }
        
        let subject = "Invoice for Your Recent Purchase"
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
    func fetchDefaultAddress(completion: @escaping (Result<Address, Error>) -> Void) {
            guard let customerId = SharedDataRepository.instance.customerId else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is missing"])
                completion(.failure(error))
                return
            }
            
            let urlString = "https://\(APIConfig.apiKey):\(APIConfig.password)@\(APIConfig.hostName)/admin/api/\(APIConfig.version)/customers/\(customerId)/addresses.json?limit"
            
            networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { [weak self] (result: Result<AddressListResponse, Error>) in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let defaultAddress = response.addresses.first(where: { $0.default == true }) {
                        self.addresses = response.addresses
                        completion(.success(defaultAddress))
                    } else {
                        let error = NSError(domain: "PaymentMethodsViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "No default address found"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Failed to fetch addresses: \(error)")
                    completion(.failure(error))
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
