//
//  ShoppingCartViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 14/06/2024.
//

import Foundation
class ShoppingCartViewModel {
    private let draftOrderService = DraftOrderNetworkService()
    var draftOrder: OneDraftOrderResponse? {
        didSet {
            updateTotalAmount()
        }
    }
    var totalAmount: String = ""
    
    var onDraftOrderUpdated: (() -> Void)?
    var onTotalAmountUpdated: (() -> Void)?
    
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
        guard var lineItem = draftOrder?.draftOrder?.lineItems[index] else { return }
        lineItem.quantity += 1
        var updatedLineItems = draftOrder?.draftOrder?.lineItems ?? []
        updatedLineItems[index] = lineItem
        draftOrder?.draftOrder?.lineItems = updatedLineItems
        onDraftOrderUpdated?()
        updateDraftOrder()
    }
    
    func decrementQuantity(at index: Int) {
        guard var lineItem = draftOrder?.draftOrder?.lineItems[index], lineItem.quantity > 1 else { return }
        lineItem.quantity -= 1
        draftOrder?.draftOrder?.lineItems[index] = lineItem
        onDraftOrderUpdated?()
        updateDraftOrder()
    }
    
    func deleteItem(at index: Int) {
        draftOrder?.draftOrder?.lineItems.remove(at: index)
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
