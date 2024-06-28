//
//  ContactUsViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class ContactUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneView.layer.shadowRadius = 4.0
        phoneView.layer.cornerRadius = 10.0
        phoneView.layer.shadowColor = UIColor.black.cgColor
        phoneView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        phoneView.layer.shadowOpacity = 0.5
        
        emailView.layer.shadowRadius = 4.0
        emailView.layer.cornerRadius = 10.0
        emailView.layer.shadowColor = UIColor.black.cgColor
        emailView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        emailView.layer.shadowOpacity = 0.5
        self.title = "Contact Us"
    }
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var emailView: UIView!
}
