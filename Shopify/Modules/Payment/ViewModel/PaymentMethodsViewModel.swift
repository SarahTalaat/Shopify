//
//  PaymentMethodsViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
//

import Foundation
import PassKit
import Reachability
import Alamofire

class PaymentMethodsViewModel: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    enum PaymentMethod {
        case cash
        case applePay
    }
    let networkService = NetworkServiceAuthentication.instance
    
    private var reachability: Reachability?
    var selectedPaymentMethod: PaymentMethod?
    var lineItem: LineItem?
    var order: Orders?
    var ordersSend: OrdersSend?
    var invoice: Invoice?
    var invoiceResponse: InvoiceResponse?
    var draftOrderId: Int?
    var exchangeRates: [String: Double] = [:]
    var totalDiscounts : String?
    var defCurrency: String = "EGP"
    var totalAmount: String?
    private var addresses: [Address] = []
    var displayedLineItems: [LineItem] = []
    private var viewModel = ShoppingCartViewModel()
    var showAlertClosure: (() -> Void)?
    func selectPaymentMethod(_ method: PaymentMethod) {
        selectedPaymentMethod = method
    }
    override init() {
        super.init()
        setupReachability()
        fetchExchangeRates()
        
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
    private func setupReachability() {
        reachability = try? Reachability()
        
        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        
        reachability?.whenUnreachable = { _ in
            self.showNoInternetAlert()
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func showNoInternetAlert() {
        self.showAlertClosure?()
    }
    func formatPriceWithCurrency(price: String) -> String {
        guard let amount = Double(price) else { return "0.00" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
    func fetchExchangeRates() {
        let exchangeRateApiService = ExchangeRateApiService()
        exchangeRateApiService.getLatestRates { [weak self] result in
            switch result {
            case .success(let response):
                self?.exchangeRates = response.conversion_rates
            case .failure(let error):
                print("Error fetching exchange rates: \(error)")
            }
        }
    }
    func convertAmountToCurrency(amount: Double, currency: String) -> Double {
        guard let rate = exchangeRates[currency] else { return amount }
        return amount * rate
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
        request.currencyCode = defCurrency  // Use selected currency here
        
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
        processPaymentAuthorization(payment: payment) { success in
            if success {
                
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            } else {
                
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            }
        }
    }
    
    private func processPaymentAuthorization(payment: PKPayment, completion: @escaping (Bool) -> Void) {
        postOrder { success in
            completion(success)
        }
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
        
        // Ensure totalAmount is properly calculated and includes discounts
        var totalPrice: Double = 0.0
        if let totalAmount = totalAmount, let totalAmountValue = Double(totalAmount) {
            totalPrice = totalAmountValue
        }
        
        print(email)
        print(defCurrency)
        print(unwrappedLineItems)
        print(totalPrice)
        print(totalDiscounts)
        
        order = Orders(
            id: nil,
            order_number: nil,
            created_at: nil,
            currency: defCurrency,
            email: email,
            total_price: String(totalPrice),
            total_discounts: totalDiscounts ?? "0.00",
            total_tax: nil,
            line_items: unwrappedLineItems,
            inventory_behaviour: "decrement_obeying_policy",
            subtotal_price : nil,
            total_outstanding: nil,
            current_total_discounts : totalDiscounts ?? "0.00"
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
        
        
        let urlString = APIConfig.customers.urlForAddresses(customerId: customerId)
        
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
        FirebaseAuthService.instance.getShoppingCartId(email: email) { shoppingCartId, error in
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
    func putDraftOrder() {
        getUserDraftOrderId { draftOrderId in
            guard let draftOrderId = draftOrderId else {
                print("Failed to get draft order ID.")
                return
            }
            
            let lineItem: [String: Any] = [
                "variant_id": 44382096457889,
                "quantity": 1
            ]
            
            let draftOrderDictionary: [String: Any] = [
                "draft_order": [
                    "line_items": [lineItem]
                ]
            ]
            
            print("Draft Order Dictionary: \(draftOrderDictionary)")
            
            self.networkService.requestFunction(
                urlString: "https://mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/\(draftOrderId).json",
                method: .put,
                model: draftOrderDictionary
            ) { (result: Result<OneDraftOrderResponse, Error>) in
                switch result {
                case .success:
                    print("Line item added successfully!")
                case .failure(let error):
                    print("Failed to add line item: \(error.localizedDescription)")
                    if let responseError = error as? AFError, case let .responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode)) = responseError {
                        print("Status code: \(statusCode)")
                        // Handle specific status codes if needed
                    }
                    // Print the full error for additional debugging information
                    print("Error details: \(error)")
                }
            }
        }
    }
    
}
