//
//  SettingsScreenViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 03/06/2024.
//

import UIKit

class SettingsScreenViewController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var currentAddress: UILabel!

  //  var sharedMethods: SharedMethods?
   
    @IBAction func addressBtn(_ sender: UIButton) {
         let addressVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
      
        navigationController?.pushViewController(addressVC, animated: true)
    }
    
    @IBAction func currencyBtn(_ sender: UIButton) {
        let currencyVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "currencyViewController") as! CurrencyViewController
     
        navigationController?.pushViewController(currencyVC, animated: true)
    }
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currentCurrency: UILabel!
   
    
    @IBAction func contacBtn(_ sender: UIButton) {
        let contactUsVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "contactViewController") as! ContactUsViewController

        navigationController?.pushViewController(contactUsVC, animated: true)
    }
    @IBAction func aboutBtn(_ sender: UIButton) {
        let aboutUsVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "aboutUsViewController") as! AboutUsViewController
     
        navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var aboutView: UIView!
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
        navigationController?.pushViewController(signUpVC, animated: true)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactView.layer.shadowRadius = 4.0
        contactView.layer.cornerRadius = 10.0
        contactView.layer.shadowColor = UIColor.black.cgColor
        contactView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        contactView.layer.shadowOpacity = 0.5
        
        aboutView.layer.shadowRadius = 4.0
        aboutView.layer.cornerRadius = 10.0
        aboutView.layer.shadowColor = UIColor.black.cgColor
        aboutView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        aboutView.layer.shadowOpacity = 0.5
        
        addressView.layer.shadowRadius = 4.0
        addressView.layer.cornerRadius = 10.0
        addressView.layer.shadowColor = UIColor.black.cgColor
        addressView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addressView.layer.shadowOpacity = 0.5
        
        currencyView.layer.shadowRadius = 4.0
        currencyView.layer.cornerRadius = 10.0
        currencyView.layer.shadowColor = UIColor.black.cgColor
        currencyView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        currencyView.layer.shadowOpacity = 0.5
        
        print("test settings")
        print("test settings")
        

    }
    

    

    

}
