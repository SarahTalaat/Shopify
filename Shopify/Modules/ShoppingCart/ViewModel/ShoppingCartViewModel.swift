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
    var draftOrder: OneDraftOrderResponse? {
        didSet {
            updateTotalAmount()
        }
    }
    var totalAmount: String = ""
    
    var onDraftOrderUpdated: (() -> Void)?
    var onTotalAmountUpdated: (() -> Void)?
    
    func fetchDraftOrders() {
        guard let draftOrderIdString = UserDefaults.standard.string(forKey: Constants.userDraftId),
              let draftOrderId = Int(draftOrderIdString) else {
            return
        }
        print("SC: draftOrderId fetchDraftOrders: \(draftOrderId)")

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
        guard let draftOrderIdString = UserDefaults.standard.string(forKey: Constants.userDraftId),
              let draftOrderId = Int(draftOrderIdString) else {
            return
        }
        print("SC: draftOrderId fetchDraftOrders: \(draftOrderId)")
        
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
    
    func getDraftOrderID(email: String) {
        FirebaseAuthService().getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                print("kkk *Failed* to retrieve shopping cart ID: \(error.localizedDescription)")
            } else if let shoppingCartId = shoppingCartId {
                UserDefaults.standard.set(shoppingCartId, forKey: Constants.userDraftId)
                self.fetchDraftOrders()
                print("kkk *PD* Shopping cart ID found: \(shoppingCartId)")
                SharedDataRepository.instance.draftOrderId = shoppingCartId
                print("kkk *PD* Singleton draft id: \(SharedDataRepository.instance.draftOrderId)")
            } else {
                print("kkk *PD* No shopping cart ID found for this user.")
            }
        }
    }
    
    func getUserDraftOrderId(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
        let email = SharedDataRepository.instance.customerEmail ?? "No email"
        self.getDraftOrderID(email: email)
        }
    }
}
