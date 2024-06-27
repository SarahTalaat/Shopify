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
          // filterLineItems()
            updateTotalAmount()
        }
    }
    var totalAmount: String = ""
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

           guard let draftOrder = draftOrder else { return }
           totalAmount = draftOrder.draftOrder?.totalPrice ?? "total price"
           onTotalAmountUpdated?()
       }

//         guard let draftOrder = draftOrder else { return }
//         let totalPrice = draftOrder.draftOrder?.lineItems.reduce(0.0) { result, lineItem in
//             if lineItem.variantId != excludedVariantId {
//                 let price = (lineItem.price as NSString).doubleValue
//                 let quantity = Double(lineItem.quantity)
//                 return (result ?? 0.0) + (price * quantity)
//             } else {
//                 return result
//             }
//         } ?? 0.0
        
//         totalAmount = String(format: "%.2f", totalPrice)
//         onTotalAmountUpdated?()
//     }
  
    
    func incrementQuantity(at index: Int) {
        guard let lineItem = draftOrder?.draftOrder?.lineItems[index],
              let productId = lineItem.productId else {
            return
        }
        
        let urlString = APIConfig.endPoint("products/\(productId)").url
        
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { [weak self] (result: Result<OneProductResponse, Error>) in
            switch result {
            case .success(let productResponse):
                let inventoryQuantity = productResponse.product.variants.first?.inventory_quantity ?? 0
                let maxQuantity = inventoryQuantity <= 5 ? inventoryQuantity : inventoryQuantity / 2
                
                if lineItem.quantity + 1 > maxQuantity {
                    self?.onAlertMessage?("You cannot add more of this item. Maximum allowed quantity is \(maxQuantity).")
                } else {
                    var updatedLineItem = lineItem
                    updatedLineItem.quantity += 1
                    self?.updateLineItem(at: index, with: updatedLineItem)
                }
                
            case .failure(let error):
                print("Failed to fetch product: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.onAlertMessage?("Failed to fetch product details")
                }
            }
        }
    }

    func decrementQuantity(at index: Int) {
        guard var lineItem = draftOrder?.draftOrder?.lineItems[index], lineItem.quantity > 1 else { return }
        lineItem.quantity -= 1
        updateLineItem(at: index, with: lineItem)
    }
    
    func deleteItem(at index: Int) {
        draftOrder?.draftOrder?.lineItems.remove(at: index)
        updateDraftOrder()
        onDraftOrderUpdated?()
    }
    
    private func updateLineItem(at index: Int, with lineItem: LineItem) {
        draftOrder?.draftOrder?.lineItems[index] = lineItem
        onDraftOrderUpdated?()
        saveChanges()
    }
    
    func updateDraftOrder() {
            guard let draftOrderIdString = UserDefaults.standard.string(forKey: Constants.userDraftId),
                  let draftOrderId = Int(draftOrderIdString),
                  let draftOrder = draftOrder else {
                return
            }

            print("SC: draftOrderId fetchDraftOrders: \(draftOrderId)")


            let urlString = APIConfig.endPoint("draft_orders/\(draftOrderId)").url
            guard let draftOrderDetails = draftOrder.draftOrder else {
                print("Draft order details are nil")
                return
            }

        // Convert draft order to dictionary representation
        guard let draftOrderDetails = draftOrder.draftOrder else {
            print("Draft order details are nil")
            return
        }
//        let draftOrderDictionary: [String: Any] = ["draft_order": draftOrderDetails.toDictionary()]


            let draftOrderDictionary = draftOrderDetails.toDraftOrderDictionary()

            networkService.requestFunction(urlString: urlString, method: .put, model: ["draft_order": draftOrderDictionary]) { [weak self] (result: Result<OneDraftOrderResponse, Error>) in
                switch result {
                case .success(let updatedDraftOrder):
                    self?.draftOrder = updatedDraftOrder
                    self?.onDraftOrderUpdated?()
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
            
            networkService.requestFunction(urlString: APIConfig.usd.url2, method: .get, model: [:]){ (result: Result<ExchangeRatesResponse, Error>) in
                switch result {
                case .success(let response):
                    print("PD Exchange Rates Response\(response)")
                    self.exchangeRates = response.conversion_rates
                    self.onDraftOrderUpdated?()
                case .failure(let error):
                    print(error)
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

//    private func filterLineItems() {
//        guard let draftOrder = draftOrder, var lineItems = draftOrder.draftOrder?.lineItems else { return }
//        if let index = lineItems.firstIndex(where: { $0.variantId == 44382096457889 }) {
//            lineItems.remove(at: index)
//            self.draftOrder?.draftOrder?.lineItems = lineItems
//        }
//    }
    
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
