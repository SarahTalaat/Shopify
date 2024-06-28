//
//  PaymentViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    
    private var viewModel = PaymentMethodsViewModel()
    var shoppingViewModel = ShoppingCartViewModel()
    var defaultAddress: Address?
    var lineItems: [LineItem]?

    @IBOutlet weak var appleButton: UIButton!
    
  
    var totalAmount: String? {
            didSet {
                if isViewLoaded {
                    updateTotalAmountLabel()
                }
            }
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
    
            setupUI()
            setupGestures()
            self.title = "Payment"
            fetchDefaultAddress()
            if let lineItems = lineItems {
                viewModel.setupOrder(lineItem: lineItems)
            }
            updateTotalAmountLabel()
        }

      
    private func showNoInternetAlert() {
           let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
        private func updateTotalAmountLabel() {
            if let totalAmount = totalAmount {
                viewModel.setTotalAmount(totalAmount)
                viewModel.updatePaymentSummaryItems(totalAmount: totalAmount)
            }
        }

        func updateGrandTotal(with amount: String) {
            totalAmount = amount
            updateTotalAmountLabel()
        }

        private func setupUI() {
            [cashView, applePayView, addressView].forEach { view in
                view?.layer.shadowRadius = 4.0
                view?.layer.cornerRadius = 10.0
                view?.layer.shadowColor = UIColor.black.cgColor
                view?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                view?.layer.shadowOpacity = 0.5
            }
            
            
            appleButton.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
        }

        private func setupGestures() {
            let cashTapGesture = UITapGestureRecognizer(target: self, action: #selector(cashViewTapped))
            cashView.addGestureRecognizer(cashTapGesture)
            
            let applePayTapGesture = UITapGestureRecognizer(target: self, action: #selector(applePayViewTapped))
            applePayView.addGestureRecognizer(applePayTapGesture)
        }

        @objc private func tapForPay() {
            let controller = PKPaymentAuthorizationViewController(paymentRequest: viewModel.paymentRequest)
            if controller != nil {
                controller!.delegate = viewModel
                present(controller!, animated: true) {
                    print("Completed")
                }
            }
        }

    
    @IBAction func placeOrderBtn(_ sender: UIButton) {
        guard let lineItems = lineItems else {
                    print("Line items are not set")
                    return
                }

                guard let selectedPaymentMethod = viewModel.selectedPaymentMethod else {
                    let alert = UIAlertController(title: "Payment Method", message: "Please select a payment method.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                guard let addressLabel = customerPaymentAddress, addressLabel.text != "Address Details" else {
                    let alert = UIAlertController(title: "Address", message: "Please provide a shipping address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }

        viewModel.postOrder { success in
                 DispatchQueue.main.async {
                     let title: String
                     let message: String
                     if success {
                         title = "Order Placed"
                         message = "Your order has been successfully placed."
                         // Clear the cart and update the draft order
                         //self.shoppingCartViewModel.clearDisplayedLineItems() // Add this line
                         self.clearCartAndDraftOrder() // Add this line
                         if let homeViewController = self.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
                             self.navigationController?.popToViewController(homeViewController, animated: true)
                         }
                     } else {
                         title = "Error"
                         message = "Failed to place order. Please try again."
                     }


                     let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                 }
             }

             viewModel.processInvoicePosting()
         }
    func clearCartAndDraftOrder() {
        print("Clearing cart and draft order, keeping dummy line item")

           // Clear the line items from the shopping cart view model, except for the dummy line item
        shoppingViewModel.displayedLineItems.removeAll { $0.variantId != 44382096457889 }

           // Update the draft order
           if var draftOrder = shoppingViewModel.draftOrder?.draftOrder {
               draftOrder.lineItems.removeAll { $0.variantId != 44382096457889 }
               shoppingViewModel.draftOrder?.draftOrder = draftOrder
               shoppingViewModel.updateDraftOrder()
           }
    }
        
    

    @IBOutlet weak var cashView: UIView!
    
    @IBOutlet weak var applePayView: UIView!
    
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var customerPaymentAddress: UILabel!
    
    @IBAction func changeAddressBtn(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
            addressVC.selectionDelegate = self
            navigationController?.pushViewController(addressVC, animated: true)
    }
  
    @IBAction func cashBtn(_ sender: UIButton) {
        print(totalAmount ?? "No total amount")
           
           let numericAmount = totalAmount?.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
           

           if let totalAmountDouble = Double(numericAmount ?? "0.0"), totalAmountDouble > 500 {
               let alert = UIAlertController(title: "Payment Alert", message: "Total amount exceeds 500. Please choose another payment method.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
           } else {
               selectPaymentMethod(.cash)
           }
    }
    
    @IBAction func appleBtn(_ sender: UIButton) {
        selectPaymentMethod(.applePay)
    }
    
    private func selectPaymentMethod(_ method: PaymentMethodsViewModel.PaymentMethod) {
        viewModel.selectPaymentMethod(method)
        switch method {
        case .cash:
            cashView.layer.borderWidth = 2.0
            cashView.layer.borderColor = UIColor.green.cgColor
            cashView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            
            applePayView.layer.borderWidth = 0.0
            applePayView.backgroundColor = UIColor.clear
        case .applePay:
            applePayView.layer.borderWidth = 2.0
            applePayView.layer.borderColor = UIColor.green.cgColor
            applePayView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            
            cashView.layer.borderWidth = 0.0
            cashView.backgroundColor = UIColor.clear
        }
    }
        
    @objc private func cashViewTapped() {
        selectPaymentMethod(.cash)
        print(totalAmount)
    }
        
        @objc private func applePayViewTapped() {
            selectPaymentMethod(.applePay)
        }
        
        private func fetchDefaultAddress() {
            viewModel.fetchDefaultAddress { result in
                       switch result {
                       case .success(let defaultAddress):
                           self.defaultAddress = defaultAddress
                           self.updateAddressLabel()
                       case .failure(let error):
                           print("Failed to fetch default address: \(error)")
                         
                       }
                   }
        }
        
        func updateAddressLabel() {
            if let defaultAddress = defaultAddress {
                customerPaymentAddress.text = "\(defaultAddress.first_name) \(defaultAddress.address1), \(defaultAddress.city), \(defaultAddress.country)"
            } else {
                customerPaymentAddress.text = "No address selected"
            }
        }
  
    }
    

    extension PaymentViewController: AddressSelectionDelegate {
        func didSelectAddress(_ address: Address, completion: @escaping () -> Void) {
            defaultAddress = address
            updateAddressLabel()
            completion()
        }
}
