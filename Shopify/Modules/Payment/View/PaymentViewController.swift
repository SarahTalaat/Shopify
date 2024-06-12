//
//  PaymentViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit
import PassKit
class PaymentViewController: UIViewController {
    private var viewModel = PaymentViewModel()
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           setupUI()
           setupGestures()
           self.title = "Choose Payment Method"
       }
       
       private func setupUI() {
           [cashView, applePayView,addressView].forEach { view in
               view?.layer.shadowRadius = 4.0
               view?.layer.cornerRadius = 10.0
               view?.layer.shadowColor = UIColor.black.cgColor
               view?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
               view?.layer.shadowOpacity = 0.5
           }
           
           unCheckedApplePay.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
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
 
   
    @IBAction func continuePaymentBtn(_ sender: UIButton) {
        let coupontUsVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "CouponViewController") as? CouponViewController
        if let sheet = coupontUsVC?.sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 40
            
        }
  
       present(coupontUsVC!, animated: true, completion: nil)
    }
    @IBOutlet weak var cashView: UIView!
    
    @IBOutlet weak var applePayView: UIView!
    
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var customerPaymentAddress: UILabel!
    
    @IBAction func changeAddressBtn(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
     
       navigationController?.pushViewController(addressVC, animated: true)
    }
    @IBAction func unCheckedCashBtn(_ sender: UIButton) {
        selectPaymentMethod(.cash)
    }
    
    @IBAction func unCheckedApplepayBtn(_ sender: UIButton) {
        selectPaymentMethod(.applePay)
    }
    
    @IBOutlet weak var unCheckedApplePay: UIButton!
    @IBOutlet weak var unCheckedCash: UIButton!
    
    private func selectPaymentMethod(_ method: PaymentViewModel.PaymentMethod) {
           viewModel.selectPaymentMethod(method)
           switch method {
           case .cash:
               unCheckedCash.setImage(UIImage(named: "checked.png"), for: .normal)
               unCheckedApplePay.setImage(UIImage(named: "unchecked.png"), for: .normal)
           case .applePay:
               unCheckedCash.setImage(UIImage(named: "unchecked.png"), for: .normal)
               unCheckedApplePay.setImage(UIImage(named: "checked.png"), for: .normal)
           }
       }
       
       @objc private func cashViewTapped() {
           selectPaymentMethod(.cash)
       }
       
       @objc private func applePayViewTapped() {
           selectPaymentMethod(.applePay)
       }
}

