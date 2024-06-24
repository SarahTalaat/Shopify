//
//  NewAddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit
import Reachability
class NewAddressViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    var selectedDefaultAddressId: Int?
    var viewModel = NewAddressViewModel()
    @IBOutlet weak var fullNameTF: UITextField!
    
    @IBOutlet weak var newAddressTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var zipCodeTF: UITextField!
    
    let cityPicker = UIPickerView()
    var reachability: Reachability?
    
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
        
        fullNameTF.delegate = self
        newAddressTF.delegate = self
        cityTF.delegate = self
        stateTF.delegate = self
        zipCodeTF.delegate = self
        
        if let customerId = SharedDataRepository.instance.customerId {
            viewModel.customerId = customerId
        } else {
            print("Error: customerId is nil")
        }
        
        // Setup reachability
        setupReachability()
    }
    
    deinit {
        reachability?.stopNotifier()
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
        return viewModel.egyptGovernorates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.egyptGovernorates[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTF.text = viewModel.egyptGovernorates[row]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case fullNameTF:
            viewModel.fullName = textField.text ?? ""
        case newAddressTF:
            viewModel.newAddress = textField.text ?? ""
        case cityTF:
            viewModel.city = textField.text ?? ""
        case stateTF:
            viewModel.state = textField.text ?? ""
            if viewModel.state.lowercased() != "egypt" {
                let alert = UIAlertController(title: "Invalid Country", message: "We currently only support addresses in Egypt.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                textField.text = ""
            }
        case zipCodeTF:
            viewModel.zipCode = textField.text ?? ""
        default:
            break
        }
    }
    
    func setupReachability() {
        reachability = try? Reachability()
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        
        switch reachability.connection {
        case .wifi, .cellular:
            print("Network is reachable")
        case .none:
            print("Network is not reachable")
            showNoInternetAlert()
        @unknown default:
            print("Unknown connection status")
        }
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveAddressBtn(_ sender: UIButton) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        guard let reachability = reachability else {
            showNoInternetAlert()
            return
        }
        
        switch reachability.connection {
        case .wifi, .cellular:
            if viewModel.isAddressValid() {
                viewModel.postNewAddress { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let address):
                            print("Address successfully posted: \(address)")
                            let successAlert = UIAlertController(title: "Success", message: "Address saved successfully.", preferredStyle: .alert)
                            successAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                self.navigationController?.popViewController(animated: true)
                            })
                            self.present(successAlert, animated: true, completion: nil)
                        case .failure(let error):
                            print("Failed to post address: \(error)")
                            let errorAlert = UIAlertController(title: "Error", message: "Failed to save address. Please try again.", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "All fields are required.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        case .unavailable:
            showNoInternetAlert()
        case .none:
            let alert = UIAlertController(title: "Error", message: "Network status unknown. Please check your internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
