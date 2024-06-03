//
//  CurrencyViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class CurrencyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        USDView.layer.shadowRadius = 4.0
        USDView.layer.cornerRadius = 10.0
        USDView.layer.shadowColor = UIColor.black.cgColor
        USDView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        USDView.layer.shadowOpacity = 0.5
        
        EGPView.layer.shadowRadius = 4.0
        EGPView.layer.cornerRadius = 10.0
        EGPView.layer.shadowColor = UIColor.black.cgColor
        EGPView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        EGPView.layer.shadowOpacity = 0.5
        print("gfjhds")
    }
    
    @IBOutlet weak var USDView: UIView!
    
    
    @IBOutlet weak var EGPView: UIView!
    
}
