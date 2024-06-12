//
//  PaymentViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit
import PassKit
class PaymentViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated:true ,completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    
    private var paymentRequest : PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay,.masterCard, .visa]
        request.supportedCountries = ["EG","US"]
        request.merchantCapabilities = .capability3DS
        
        request.countryCode = "EG"
        request.currencyCode = "EGP"
        
        if UserDefaults.standard.string(forKey: "Currency") == "EGP" {
            request.currencyCode = "EGP"
        } else{
            request.currencyCode = "USD"
        }
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "T-shirt", amount:1200 )]
        
        return request
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        cashView.layer.shadowRadius = 4.0
        cashView.layer.cornerRadius = 10.0
        cashView.layer.shadowColor = UIColor.black.cgColor
        cashView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cashView.layer.shadowOpacity = 0.5
        
        applePayView.layer.shadowRadius = 4.0
        applePayView.layer.cornerRadius = 10.0
        applePayView.layer.shadowColor = UIColor.black.cgColor
        applePayView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        applePayView.layer.shadowOpacity = 0.5
        self.title = "Choose Payment Method"
        
        let cashTapGesture = UITapGestureRecognizer(target: self, action: #selector(cashViewTapped))
              cashView.addGestureRecognizer(cashTapGesture)
              
        let applePayTapGesture = UITapGestureRecognizer(target: self, action: #selector(applePayViewTapped))
              applePayView.addGestureRecognizer(applePayTapGesture)
        
        self.unCheckedApplePay.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
    }
    
    @objc func tapForPay(){
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true) {
                print("Completed")
            }
        }
    }
    var selectedPaymentMethod: PaymentMethod?

       enum PaymentMethod {
           case cash
           case applePay
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
    
    private func selectPaymentMethod(_ method: PaymentMethod) {
           selectedPaymentMethod = method
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

