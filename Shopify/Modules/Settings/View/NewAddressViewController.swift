//
//  NewAddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class NewAddressViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    var selectedDefaultAddressId: Int?
   // var viewModel = NewAddressViewModel()
    @IBOutlet weak var fullNameTF: UITextField!
    
    @IBOutlet weak var newAddressTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var zipCodeTF: UITextField!

    let cityPicker = UIPickerView()
       let egyptGovernorates = [
           "Cairo", "Alexandria", "Giza", "Port Said", "Suez", "Luxor", "Aswan", "Asyut",
           "Beheira", "Beni Suef", "Dakahlia", "Damietta", "Faiyum", "Gharbia", "Ismailia",
           "Kafr El Sheikh", "Matruh", "Minya", "Monufia", "New Valley", "North Sinai",
           "Qalyubia", "Qena", "Red Sea", "Sharqia", "Sohag", "South Sinai"
       ]

       override func viewDidLoad() {
           super.viewDidLoad()
           fullNameTF.addPaddingToTextField()
           newAddressTF.addPaddingToTextField()
           cityTF.addPaddingToTextField()
           stateTF.addPaddingToTextField()
           zipCodeTF.addPaddingToTextField()
           self.title = "New Address"
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tapGesture.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture)
           
           setupCityPicker()
           
           // Set the delegate for stateTF
           stateTF.delegate = self
       }

       @objc func dismissKeyboard() {
           view.endEditing(true)
       }

       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.tabBarController?.tabBar.isHidden = true
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.tabBarController?.tabBar.isHidden = false
       }

       func setupCityPicker() {
           cityPicker.delegate = self
           cityPicker.dataSource = self
           cityTF.inputView = cityPicker
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTappedCity))
           toolbar.setItems([doneButton], animated: false)
           toolbar.isUserInteractionEnabled = true
           cityTF.inputAccessoryView = toolbar
       }

       @objc func doneTappedCity() {
           cityTF.resignFirstResponder()
       }

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return egyptGovernorates.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return egyptGovernorates[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           cityTF.text = egyptGovernorates[row]
       }

       func textFieldDidEndEditing(_ textField: UITextField) {
           if textField == stateTF {
               let allowedState = "Egypt"
               if textField.text?.lowercased() != allowedState.lowercased() {
                   let alert = UIAlertController(title: "Invalid Input", message: "We currently only support addresses in Egypt.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   present(alert, animated: true, completion: nil)
                   textField.text = ""
               }
           }
       }


    
    @IBAction func saveAddressBtn(_ sender: UIButton) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
               guard let fullName = fullNameTF.text, !fullName.isEmpty,
                     let newAddress = newAddressTF.text, !newAddress.isEmpty,
                     let city = cityTF.text, !city.isEmpty,
                     let country = stateTF.text, !country.isEmpty,
                     let zipCode = zipCodeTF.text, !zipCode.isEmpty else {
                   let alert = UIAlertController(title: "Error", message: "All fields are required.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   present(alert, animated: true, completion: nil)
                   return
               }

               let address = Address(id: nil, first_name: fullName, address1: newAddress, city: city, country: country, zip: zipCode, `default`: false)

               TryAddressNetworkService.shared.postNewAddress(address: address) { result in
                   switch result {
                   case .success(let address):
                       print("Address successfully posted: \(address)")
                       DispatchQueue.main.async {
                           let successAlert = UIAlertController(title: "Success", message: "Address saved successfully.", preferredStyle: .alert)
                           successAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                               self.navigationController?.popViewController(animated: true)
                           })
                           self.present(successAlert, animated: true, completion: nil)
                       }
                   case .failure(let error):
                       print("Failed to post address: \(error)")
                       DispatchQueue.main.async {
                           let errorAlert = UIAlertController(title: "Error", message: "Failed to save address. Please try again.", preferredStyle: .alert)
                           errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           self.present(errorAlert, animated: true, completion: nil)
                       }
                   }
               }
           }
}

extension UITextField {
    func addPaddingToTextField() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
