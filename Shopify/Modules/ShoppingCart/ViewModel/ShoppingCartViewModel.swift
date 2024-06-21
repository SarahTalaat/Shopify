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
    private let draftOrderService = DraftOrderNetworkService()
    private let disposeBag = DisposeBag()
    
    var draftOrder: OneDraftOrderResponse? {
        didSet {
            updateTotalAmount()
        }
    }
    var totalAmount: String = ""
    
    var onDraftOrderUpdated: (() -> Void)?
    var onTotalAmountUpdated: (() -> Void)?
    var onAlertMessage: ((String) -> Void)?
    
    func fetchDraftOrders() {
        draftOrderService.fetchDraftOrders { [weak self] result in
            switch result {
            case .success(let draftOrder):
                self?.draftOrder = draftOrder
                self?.onDraftOrderUpdated?()
            case .failure(let error):
                print("Failed to fetch draft orders: \(error.localizedDescription)")
            }
        }
    }
    
    func updateTotalAmount() {
        guard let draftOrder = draftOrder else { return }
        totalAmount = draftOrder.draftOrder?.totalPrice ?? "total price"
        onTotalAmountUpdated?()
    }
    
    func incrementQuantity(at index: Int) {
        guard let lineItem = draftOrder?.draftOrder?.lineItems[index],
              let productId = lineItem.productId else { return }
        
        draftOrderService.fetchProduct(productId: productId) { [weak self] result in
            switch result {
            case .success(let product):
                let inventoryQuantity = product.variants.first?.inventory_quantity ?? 0
                let maxQuantity = inventoryQuantity / 2
                
                if lineItem.quantity + 1 > maxQuantity {
                    self?.onAlertMessage?("You cannot add more of this item. Maximum allowed quantity is \(maxQuantity).")
                } else {
                    var updatedLineItem = lineItem
                    updatedLineItem.quantity += 1
                    self?.updateLineItem(at: index, with: updatedLineItem)
                }
                
            case .failure(let error):
                print("Failed to fetch product: \(error.localizedDescription)")
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
        onDraftOrderUpdated?()
        updateDraftOrder()
    }
    
    private func updateLineItem(at index: Int, with lineItem: LineItem) {
        draftOrder?.draftOrder?.lineItems[index] = lineItem
        onDraftOrderUpdated?()
        updateDraftOrder()
    }
    
    func updateDraftOrder() {
        guard let draftOrder = draftOrder else { return }
        draftOrderService.updateDraftOrder(draftOrder: draftOrder) { [weak self] result in
            switch result {
            case .success(let updatedDraftOrder):
                self?.draftOrder = updatedDraftOrder
                self?.onDraftOrderUpdated?()
            case .failure(let error):
                print("Failed to update draft order: \(error.localizedDescription)")
            }
        }
    }
}
