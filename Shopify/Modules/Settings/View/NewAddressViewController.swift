////
////  NewAddressViewController.swift
////  Shopify
////
////  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
////
//
//import UIKit
//
//class NewAddressViewController: UIViewController {
//
//    @IBOutlet weak var fullNameTF: UITextField!
//    
//    @IBOutlet weak var newAddressTF: UITextField!
//    
//    @IBOutlet weak var cityTF: UITextField!
//    
//    @IBOutlet weak var stateTF: UITextField!
//    
//    @IBOutlet weak var zipCodeTF: UITextField!
//    
//    @IBAction func saveAddressBtn(_ sender: UIButton) {
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        guard let fullName = fullNameTF.text, !fullName.isEmpty,
//                      let newAddress = newAddressTF.text, !newAddress.isEmpty,
//                      let city = cityTF.text, !city.isEmpty,
//                      let country = stateTF.text, !country.isEmpty,
//              let zipCode = zipCodeTF.text, !zipCode.isEmpty else {
//            let alert = UIAlertController(title: "Error", message: "All fields are required.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return
//        }
//        let address = Address(id: nil, first_name: fullName, address1: newAddress, city: city, country: country, zip: zipCode)
//
//               TryAddressNetworkService.shared.postNewAddress(address: address) { result in
//                   switch result {
//                   case .success(let address):
//                       print("Address successfully posted: \(address)")
//                       DispatchQueue.main.async {
//                           let successAlert = UIAlertController(title: "Success", message: "Address saved successfully.", preferredStyle: .alert)
//                           successAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                               self.navigationController?.popViewController(animated: true)
//                           })
//                           self.present(successAlert, animated: true, completion: nil)
//                       }
//                   case .failure(let error):
//                       print("Failed to post address: \(error)")
//                       DispatchQueue.main.async {
//                           let errorAlert = UIAlertController(title: "Error", message: "Failed to save address. Please try again.", preferredStyle: .alert)
//                           errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                           self.present(errorAlert, animated: true, completion: nil)
//                       }
//                   }
//               }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fullNameTF.addPaddingToTextField()
//        newAddressTF.addPaddingToTextField()
//        cityTF.addPaddingToTextField()
//        stateTF.addPaddingToTextField()
//        zipCodeTF.addPaddingToTextField()
//        self.title = "New Address"
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            self.tabBarController?.tabBar.isHidden = true
//        }
//
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            self.tabBarController?.tabBar.isHidden = false
//        }
//
//}
//
//extension UITextField{
//    func addPaddingToTextField(){
//        let paddingView :UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//        self.rightView = paddingView
//        self.rightViewMode = .always
//    }
//}
