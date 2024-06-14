//
//  CouponsViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
//

import Foundation
class CouponsViewModel {
    
    let network = NetworkServiceAuthentication()
    let staticSubTotal: Double = 100.00
    private(set) var discountCodes: [String] = []

    var subTotal: String {
        return String(format: "$%.2f", staticSubTotal)
    }
    
    init() {
         setupOrder()
     }

    func validateCoupon(_ couponCode: String, completion: @escaping (Double?) -> Void) {
        let discountAmount: Double? = {
            if couponCode == "SUMMERSALE20OFF" {
                return 20.0
            } else if couponCode == "SUMMERSALE10OFF" {
                return 10.0
            } else {
                return nil
            }
        }()
        completion(discountAmount)
    }

    func updateTotals(with discountAmount: Double) -> (discount: String, grandTotal: String) {
        let discountValue = staticSubTotal * (discountAmount / 100.0)
        let grandTotalValue = staticSubTotal - discountValue

        return (String(format: "$%.2f", discountValue), String(format: "$%.2f", grandTotalValue))
    }

    func saveCouponCode(_ couponCode: String) {
        var usedCoupons = UserDefaults.standard.array(forKey: "usedCoupons") as? [String] ?? []
        usedCoupons.append(couponCode)
        UserDefaults.standard.set(usedCoupons, forKey: "usedCoupons")
    }

    func isCouponUsed(_ couponCode: String) -> Bool {
        let usedCoupons = UserDefaults.standard.array(forKey: "usedCoupons") as? [String] ?? []
        return usedCoupons.contains(couponCode)
    }
    
    private var lineItem: LineItemss?
     private var order: Orders?
     private var ordersSend: OrdersSend?

     func setupOrder() {
         lineItem = LineItemss(
             id: 8048429695137,
             name: "PALLADIUM | PALLATECH HI TX | CHEVRON",
             price: "159.95",
             quantity: 2,
             title: "PALLADIUM | PALLATECH HI TX | CHEVRON",
             total_discount: nil
         )

         order = Orders(
             id: nil,
             confirmation_number: nil,
             confirmed: nil,
             created_at: nil,
             currency: "EUR",
             email: nil,
             financial_status: nil,
             order_number: nil,
             source_name: nil,
             tags: nil,
             token: nil,
             total_discounts: nil,
             total_line_items_price: nil,
             total_price: nil,
             line_items: [lineItem!]
         )

         ordersSend = OrdersSend(order: order!)
     }
     
     func postOrder() {
         guard let ordersSend = ordersSend else {
             print("Order is not set up correctly")
             return
         }
         
         NetworkUtilities.postData(data: ordersSend, endpoint: "orders.json") { success in
             if success {
                 print("Order posted successfully!")
             } else {
                 print("Failed to post order.")
             }
         }
     }
 }
