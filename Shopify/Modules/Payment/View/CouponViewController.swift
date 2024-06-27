//
//  CouponViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 03/06/2024.
//

import UIKit
protocol CouponViewControllerDelegate: AnyObject {
    func updateGrandTotal(with amount: String)
    func updateGrandTotalFromCoupon(with amount: String)
   
}

class CouponViewController: UIViewController {
    
    weak var delegate: CouponViewControllerDelegate?
    private let viewModel = CouponsViewModel()
    var subtotal: String?
    var updatedTotalAmount: String?
    override func viewDidLoad() {
            super.viewDidLoad()
            
            if let subtotal = subtotal {
                subTotal.text = subtotal
                viewModel.subTotal = subtotal
            }
            
            discount.text = "$0.00"
            grandTotal.text = subTotal.text
            
            viewModel.fetchExchangeRates()
            updateUIWithCurrency()
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
                
                guard let customerId = SharedDataRepository.instance.customerId else {
                    return
                }
                
                if viewModel.isCouponUsed(couponCode, by: customerId) {
                    showAlert(title: "Coupon Used", message: "This coupon code has already been used.")
                    validCouponTF.layer.borderColor = UIColor.red.cgColor
                    validCouponTF.layer.borderWidth = 1.0
                    return
                }
                
                viewModel.validateCoupon(couponCode) { [weak self] discountAmount in
                    guard let self = self else { return }
                    
                    if let discountAmount = discountAmount {
                        let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                        let totals = self.viewModel.updateTotals(with: discountAmount, in: selectedCurrency)
                        DispatchQueue.main.async {
                            self.discount.text = totals.discount
                            self.grandTotal.text = totals.grandTotal
                            self.updatedTotalAmount = totals.grandTotal
                            self.validCouponTF.layer.borderColor = UIColor.green.cgColor
                            self.validCouponTF.layer.borderWidth = 1.0
                            
                            self.delegate?.updateGrandTotal(with: totals.grandTotal)
                            self.delegate?.updateGrandTotalFromCoupon(with: totals.grandTotal)
                        }
                        self.viewModel.saveCouponCode(couponCode, for: customerId)
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Invalid Coupon", message: "The entered coupon code is invalid.")
                            self.validCouponTF.layer.borderColor = UIColor.red.cgColor
                            self.validCouponTF.layer.borderWidth = 1.0
                        }
                    }
                }
    }
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var grandTotal: UILabel!
    
    
    @IBAction func placePaymentBtn(_ sender: UIButton) {
        if let grandTotalAmount = grandTotal.text {
                    delegate?.updateGrandTotal(with: grandTotalAmount)
                    delegate?.updateGrandTotalFromCoupon(with: updatedTotalAmount ?? grandTotalAmount)
                }
                dismiss(animated: true, completion: nil)
            }
            
    private func updateUIWithCurrency() {
            let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
            
            if let subtotalValue = Double(viewModel.subTotal.replacingOccurrences(of: "$", with: "")) {
                let convertedSubtotal = viewModel.getConvertedValue(for: subtotalValue, in: selectedCurrency)
                self.subTotal.text = "\(String(format: "%.2f", convertedSubtotal)) \(selectedCurrency)"
            }
            
            if let discountValue = Double(discount.text?.replacingOccurrences(of: "$", with: "") ?? "0") {
                let convertedDiscount = viewModel.getConvertedValue(for: discountValue, in: selectedCurrency)
                self.discount.text = "\(String(format: "%.2f", convertedDiscount)) \(selectedCurrency)"
            }
            
            if let grandTotalValue = Double(grandTotal.text?.replacingOccurrences(of: "$", with: "") ?? "0") {
                let convertedGrandTotal = viewModel.getConvertedValue(for: grandTotalValue, in: selectedCurrency)
                self.grandTotal.text = "\(String(format: "%.2f", convertedGrandTotal)) \(selectedCurrency)"
            }
        }
        
            
            func showAlert(title: String, message: String) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }

}
