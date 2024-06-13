//
//  NewAddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class NewAddressViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var selectedDefaultAddressId: Int?
    var viewModel = NewAddressViewModel()
    @IBOutlet weak var fullNameTF: UITextField!
    
    @IBOutlet weak var newAddressTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var zipCodeTF: UITextField!
    let statePicker = UIPickerView()

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
          
          setupStatePicker()
          
          bindViewModel()
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
      
      func setupStatePicker() {
          statePicker.delegate = self
          statePicker.dataSource = self
          stateTF.inputView = statePicker
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTappedState))
          toolbar.setItems([doneButton], animated: false)
          toolbar.isUserInteractionEnabled = true
          stateTF.inputAccessoryView = toolbar
      }
      
      @objc func doneTappedState() {
          stateTF.resignFirstResponder()
      }
      
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return viewModel.states.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return viewModel.states[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          stateTF.text = viewModel.states[row]
      }
    
    @IBAction func saveAddressBtn(_ sender: UIButton) {
        viewModel.fullName = fullNameTF.text
               viewModel.newAddress = newAddressTF.text
               viewModel.city = cityTF.text
               viewModel.state = stateTF.text
               viewModel.zipCode = zipCodeTF.text
               
               viewModel.saveAddress()
           }
           
           func bindViewModel() {
               viewModel.bindErrorViewModelToController = {
                   DispatchQueue.main.async {
                       let alert = UIAlertController(title: "Error", message: self.viewModel.errorMessage, preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
                   }
               }
               
               viewModel.bindSuccessViewModelToController = {
                   DispatchQueue.main.async {
                       let successAlert = UIAlertController(title: "Success", message: self.viewModel.successMessage, preferredStyle: .alert)
                       successAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                           self.navigationController?.popViewController(animated: true)
                       })
                       self.present(successAlert, animated: true, completion: nil)
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
