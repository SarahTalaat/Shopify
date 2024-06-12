//
//  CouponViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 03/06/2024.
//

import UIKit

class CouponViewController: UIViewController {
    
    private let viewModel = CouponsViewModel()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           subTotal.text = viewModel.subTotal
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

             if viewModel.isCouponUsed(couponCode) {
                 showAlert(title: "Coupon Used", message: "This coupon code has already been used.")
                 validCouponTF.layer.borderColor = UIColor.red.cgColor
                 validCouponTF.layer.borderWidth = 1.0
                 return
             }

             viewModel.validateCoupon(couponCode) { [weak self] discountAmount in
                 guard let self = self else { return }

                 if let discountAmount = discountAmount {
                     let totals = self.viewModel.updateTotals(with: discountAmount)
                     self.discount.text = totals.discount
                     self.grandTotal.text = totals.grandTotal
                     self.viewModel.saveCouponCode(couponCode)
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
  

      func showAlert(title: String, message: String) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
      }
  
}
