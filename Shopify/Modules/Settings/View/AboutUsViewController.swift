//
//  AboutUsViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutUs.layer.shadowRadius = 4.0
        aboutUs.layer.cornerRadius = 10.0
        aboutUs.layer.shadowColor = UIColor.black.cgColor
        aboutUs.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        aboutUs.layer.shadowOpacity = 0.5
        self.title = "About Us"
    }
    

    
    @IBOutlet weak var aboutUs: UITextView!
    
}
