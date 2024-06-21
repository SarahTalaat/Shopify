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
    
    var totalAmount: String?
    var defaultAddress: Address?
    var lineItems: [LineItem]?
       
    @IBOutlet weak var appleButton: UIButton!
    override func viewDidLoad() {
          super.viewDidLoad()
          if let subtotal = totalAmount {
              viewModel.updatePaymentSummaryItems(totalAmount: subtotal)
          }
          setupUI()
          setupGestures()
          self.title = "Choose Payment Method"
          fetchDefaultAddress()
          if let lineItems = lineItems {
              viewModel.setupOrder(lineItem: lineItems)
          }
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
          
          viewModel.postOrder()
          
         
      }
    func updateGrandTotalFromCoupon(with amount: String) {
            // Update the payment view model with the grand total from the coupon
            viewModel.updatePaymentSummaryItems(totalAmount: amount)
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
        selectPaymentMethod(.cash)
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
