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
            self.title = "Choose Payment Method"
            fetchDefaultAddress()
            if let lineItems = lineItems {
                viewModel.setupOrder(lineItem: lineItems)
            }
            updateTotalAmountLabel()
        }

        private func updateTotalAmountLabel() {
            if let totalAmount = totalAmount {
                viewModel.setTotalAmount(totalAmount)
                    
                viewModel.updatePaymentSummaryItems(totalAmount: totalAmount)
            }
        

        func updateGrandTotal(with amount: String) {
            totalAmount = amount
            updateTotalAmountLabel()
        }
        print("Received total amount in PaymentVC: \(totalAmount)")
        print("Total amount value in view model: \(viewModel.totalAmount)")
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
    func updateGrandTotal(with amount: String) {
        if let totalAmount = Double(amount) {
            viewModel.updatePaymentSummaryItems(totalAmount: String(totalAmount))
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
           
           // Remove non-numeric characters (except the decimal point)
           let numericAmount = totalAmount?.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
           
           // Convert to Double
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
                cashView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
                applePayView.backgroundColor = UIColor.clear
            case .applePay:
                cashView.backgroundColor = UIColor.clear
                applePayView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
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
            TryAddressNetworkService.shared.getAddresses { result in
                switch result {
                case .success(let addresses):
                    if let defaultAddress = addresses.first(where: { $0.default == true }) {
                        self.defaultAddress = defaultAddress
                        self.updateAddressLabel()
                    }
                case .failure(let error):
                    print("Failed to fetch addresses: \(error)")
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
