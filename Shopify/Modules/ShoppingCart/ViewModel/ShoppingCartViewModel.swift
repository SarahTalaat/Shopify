//
//  ShoppingCartViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 14/06/2024.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import Cosmos

class ShoppingCartViewModel {
    private let networkService = NetworkServiceAuthentication()
    private let disposeBag = DisposeBag()

    var exchangeRates: [String: Double] = [:]
    var isVariantExcluded: Bool = false
    var draftOrder: OneDraftOrderResponse? {
        didSet {
            updateDisplayedLineItems()
            updateTotalAmount()
        }
    }
    var totalAmount: String = ""
    var displayedLineItems: [LineItem] = []
    var excludedVariantId: Int = 44382096457889
    var onDraftOrderUpdated: (() -> Void)?
    var onTotalAmountUpdated: (() -> Void)?
    var onAlertMessage: ((String) -> Void)?
    
    private let saveChangesSubject = PublishSubject<Void>()
    
    init() {
        saveChangesSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateDraftOrder()
            })
            .disposed(by: disposeBag)
        
        fetchExchangeRates()
    }
    
    func saveChanges() {
        saveChangesSubject.onNext(())
    }
    func fetchDraftOrders() {
            guard let draftOrderIdString = UserDefaults.standard.string(forKey: Constants.userDraftId),
                  let draftOrderId = Int(draftOrderIdString) else {
                return
            }
            print("SC: draftOrderId fetchDraftOrders: \(draftOrderId)")
        let urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
            networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrder):
                    self?.draftOrder = draftOrder
                    self?.onDraftOrderUpdated?()
                case .failure(let error):
                    print("Failed to fetch draft orders: \(error.localizedDescription)")
                }
            }
        }
    func fetchProductDetails(for productId: Int, completion: @escaping (Result<OneProductResponse, Error>) -> Void) {
        let urlString = APIConfig.endPoint("products/\(productId)").url
        
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<OneProductResponse, Error>) in
            switch result {
            case .success(let product):
                completion(.success(product))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTotalAmount() {
        let total = displayedLineItems.reduce(0) { result, lineItem in
            result + (Double(lineItem.price) ?? 0) * Double(lineItem.quantity)
        }
        totalAmount = String(format: "%.2f", total)
        onTotalAmountUpdated?()
    }
        

    func incrementQuantity(at index: Int) {
        guard index < displayedLineItems.count else { return }
        var lineItem = displayedLineItems[index]
        guard let productId = lineItem.productId else { return }

        let urlString = APIConfig.endPoint("products/\(productId)").url
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { [weak self] (result: Result<OneProductResponse, Error>) in
            switch result {
            case .success(let productResponse):
                let inventoryQuantity = productResponse.product.variants.first?.inventory_quantity ?? 0
                let maxQuantity = inventoryQuantity <= 5 ? inventoryQuantity : inventoryQuantity / 2

                if lineItem.quantity + 1 > maxQuantity {
                    self?.onAlertMessage?("You cannot add more of this item. Maximum allowed quantity is \(maxQuantity).")
                } else {
                    lineItem.quantity += 1
                    self?.updateLineItem(at: index, with: lineItem)
                }
            case .failure(let error):
                print("Failed to fetch product: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.onAlertMessage?("Failed to fetch product details")
                }
            }
        }
    }
    func updateDisplayedLineItems() {
           guard let draftOrder = draftOrder else {
               displayedLineItems = []
               return
           }
           
           displayedLineItems = draftOrder.draftOrder?.lineItems.filter { $0.variantId != excludedVariantId } ?? []
       }

    func decrementQuantity(at index: Int) {
        guard index < displayedLineItems.count else { return }
        var lineItem = displayedLineItems[index]

        guard lineItem.quantity > 1 else { return }

        lineItem.quantity -= 1
        updateLineItem(at: index, with: lineItem)
    }

    func deleteItem(at index: Int) {
        guard index < displayedLineItems.count else { return }
        
        let removedItemId = displayedLineItems.remove(at: index).id

        guard var lineItems = draftOrder?.draftOrder?.lineItems else { return }
        lineItems.removeAll { $0.id == removedItemId }
        draftOrder?.draftOrder?.lineItems = lineItems

        updateTotalAmount()
        onDraftOrderUpdated?()
        saveChanges()
    }

    private func updateLineItem(at index: Int, with lineItem: LineItem) {
        guard index < displayedLineItems.count else { return }

        displayedLineItems[index] = lineItem

        guard var lineItems = draftOrder?.draftOrder?.lineItems else { return }
        if let originalIndex = lineItems.firstIndex(where: { $0.id == lineItem.id }) {
            lineItems[originalIndex] = lineItem
        }
        draftOrder?.draftOrder?.lineItems = lineItems

        onDraftOrderUpdated?()
        saveChanges()
    }
    
    func updateDraftOrder() {
        guard let draftOrderIdString = UserDefaults.standard.string(forKey: Constants.userDraftId),
              let draftOrderId = Int(draftOrderIdString),
              let draftOrder = draftOrder else {
            print("Failed to fetch draftOrderId or draftOrder is nil")
            return
        }

        print("SC: draftOrderId fetchDraftOrders: \(draftOrderId)")

        let urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
        guard let draftOrderDetails = draftOrder.draftOrder else {
            print("Draft order details are nil")
            return
        }

        let draftOrderDictionary = draftOrderDetails.toDraftOrderDictionary()
        print("Draft order dictionary: \(draftOrderDictionary)")

        networkService.requestFunction(urlString: urlString, method: .put, model: ["draft_order": draftOrderDictionary]) { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case .success(let updatedDraftOrder):
                self?.draftOrder = updatedDraftOrder
                self?.onDraftOrderUpdated?()
                self?.updateDisplayedLineItems() // Ensure displayed line items are updated
                self?.updateTotalAmount() // Ensure total amount is updated
                print("Draft order updated successfully")
            case .failure(let error):
                print("Failed to update draft order: \(error.localizedDescription)")
            }
        }
    }
    func formatPriceWithCurrency(price: String) -> String {
        let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
        let exchangeRate = exchangeRates[selectedCurrency] ?? 1.0
        if let priceDouble = Double(price) {
            let convertedPrice = priceDouble * exchangeRate
            return "\(String(format: "%.2f", convertedPrice)) \(selectedCurrency)"
        } else {
            return "Invalid price"
        }
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

    func getDraftOrderID(email: String) {
        FirebaseAuthService().getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                print("kkk Failed to retrieve shopping cart ID: \(error.localizedDescription)")
            } else if let shoppingCartId = shoppingCartId {
                UserDefaults.standard.set(shoppingCartId, forKey: Constants.userDraftId)
                self.fetchDraftOrders()
                print("kkk PD Shopping cart ID found: \(shoppingCartId)")
                SharedDataRepository.instance.draftOrderId = shoppingCartId
                print("kkk PD Singleton draft id: \(SharedDataRepository.instance.draftOrderId)")
            } else {
                print("kkk PD No shopping cart ID found for this user.")
            }
        }
    }
    
    func getUserDraftOrderId() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let email = SharedDataRepository.instance.customerEmail ?? "No email"
            self.getDraftOrderID(email: email)
        }
    }
    func clearDisplayedLineItems() {
        displayedLineItems.removeAll()
          updateDraftOrder()
    }

}
extension OneDraftOrderResponseDetails {
    func toDraftOrderDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id as Any,
            "note": note as Any,
            "email": email as Any,
            "taxes_included": taxesIncluded as Any,
            "currency": currency as Any,
            "invoice_sent_at": invoiceSentAt as Any,
            "created_at": createdAt as Any,
            "updated_at": updatedAt as Any,
            "tax_exempt": taxExempt as Any,
            "completed_at": completedAt as Any,
            "name": name as Any,
            "status": status as Any,
            "line_items": lineItems.map { $0.toLineItemDictionary() },
            "shipping_address": shippingAddress as Any,
            "billing_address": billingAddress as Any,
            "invoice_url": invoiceUrl as Any,
            "applied_discount": appliedDiscount as Any,
            "order_id": orderId as Any,
            "shipping_line": shippingLine as Any,
            "tax_lines": taxLines?.map { $0.toTaxLineDictionary() } as Any,
            "tags": tags as Any,
            "note_attributes": noteAttributes as Any,
            "total_price": totalPrice,
            "subtotal_price": subtotalPrice,
            "total_tax": totalTax as Any,
            "payment_terms": paymentTerms as Any,
            "admin_graphql_api_id": adminGraphqlApiId as Any
        ]
        return dictionary
    }
}

extension LineItem {
    func toLineItemDictionary() -> [String: Any] {
        return [
            "id": id as Any,
            "variant_id": variantId as Any,
            "product_id": productId as Any,
            "title": title,
            "variant_title": variantTitle as Any,
            "sku": sku as Any,
            "vendor": vendor as Any,
            "quantity": quantity,
            "requires_shipping": requiresShipping as Any,
            "taxable": taxable as Any,
            "gift_card": giftCard as Any,
            "fulfillment_service": fulfillmentService as Any,
            "grams": grams as Any,
            "tax_lines": taxLines?.map { $0.toTaxLineDictionary() } as Any,
            "applied_discount": appliedDiscount as Any,
            "name": name as Any,
            "properties": properties as Any,
            "custom": custom as Any,
            "price": price,
            "admin_graphql_api_id": adminGraphqlApiId as Any
        ]
    }
}

extension TaxLine {
    func toTaxLineDictionary() -> [String: Any] {
        return [
            "rate": rate as Any,
            "title": title as Any,
            "price": price as Any
        ]
    }
}
