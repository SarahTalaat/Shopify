//
//  NewAddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class NewAddressViewController: UIViewController {

    @IBOutlet weak var fullNameTF: UITextField!
    
    @IBOutlet weak var newAddressTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var zipCodeTF: UITextField!
    
    @IBAction func saveAddressBtn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTF.addPaddingToTextField()
        newAddressTF.addPaddingToTextField()
        cityTF.addPaddingToTextField()
        stateTF.addPaddingToTextField()
        zipCodeTF.addPaddingToTextField()
    }
    


}

extension UITextField{
    func addPaddingToTextField(){
        let paddingView :UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
