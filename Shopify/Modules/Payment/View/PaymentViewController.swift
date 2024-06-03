//
//  PaymentViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class PaymentViewController: UIViewController {

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
    
}
