//
//  CouponViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 03/06/2024.
//

import UIKit

class CouponViewController: UIViewController {
    
    
    let staticSubTotal: Double = 100.00
    var discountCodes: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        subTotal.text = String(format: "$%.2f", staticSubTotal)
        discount.text = "$0.00"
        grandTotal.text = subTotal.text
    }



    @IBOutlet weak var subTotal: UILabel!
    
    
    @IBOutlet weak var validCouponTF: UITextField!
    
    
    @IBAction func validateBtn(_ sender: UIButton) {
        guard let couponCode = validCouponTF.text, !couponCode.isEmpty else {
                  showAlert(title: "Invalid Coupon", message: "Please enter a valid coupon code.")
                  validCouponTF.layer.borderColor = UIColor.red.cgColor
                  validCouponTF.layer.borderWidth = 1.0
                  return
              }

              if isCouponUsed(couponCode) {
                  showAlert(title: "Coupon Used", message: "This coupon code has already been used.")
                  validCouponTF.layer.borderColor = UIColor.red.cgColor
                  validCouponTF.layer.borderWidth = 1.0
                  return
              }

              validateCoupon(couponCode) { [weak self] discountAmount in
                  guard let self = self else { return }

                  if let discountAmount = discountAmount {
                      self.updateTotals(with: discountAmount)
                      self.saveCouponCode(couponCode)
                      self.validCouponTF.layer.borderColor = UIColor.green.cgColor
                      self.validCouponTF.layer.borderWidth = 1.0
                  } else {
                      self.showAlert(title: "Invalid Coupon", message: "The entered coupon code is invalid.")
                      self.validCouponTF.layer.borderColor = UIColor.red.cgColor
                      self.validCouponTF.layer.borderWidth = 1.0
                  }
              }
    }
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var grandTotal: UILabel!
    
    
    @IBAction func placePaymentBtn(_ sender: UIButton) {
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
    func updateTotals(with discountAmount: Double) {
          let discountValue = staticSubTotal * (discountAmount / 100.0)
          let grandTotalValue = staticSubTotal - discountValue

          discount.text = String(format: "$%.2f", discountValue)
          grandTotal.text = String(format: "$%.2f", grandTotalValue)
      }

      func showAlert(title: String, message: String) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
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
}
