//
//  ShoppingCartViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 14/06/2024.
//

import Foundation
class ShoppingCartViewModel {
    private let draftOrderService = DraftOrderNetworkService()
    var draftOrder: DraftOrder? {
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
    
    private func updateTotalAmount() {
        guard let draftOrder = draftOrder else { return }
        totalAmount = draftOrder.subtotal_price
        onTotalAmountUpdated?()
    }
    
    func incrementQuantity(at index: Int) {
        guard var lineItem = draftOrder?.line_items[index] else { return }
        lineItem.quantity += 1
        draftOrder?.line_items[index] = lineItem
        onDraftOrderUpdated?()
    }
    
    func decrementQuantity(at index: Int) {
        guard var lineItem = draftOrder?.line_items[index], lineItem.quantity > 1 else { return }
        lineItem.quantity -= 1
        draftOrder?.line_items[index] = lineItem
        onDraftOrderUpdated?()
    }
    
    func deleteItem(at index: Int) {
        guard var draftOrder = draftOrder else { return }
        draftOrder.line_items.remove(at: index)
        
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
