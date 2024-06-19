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



    var settingsViewModel: SettingsViewModelProtocol!

   
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
        settingsViewModel.signOut(isSignedOut: true)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
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
        
        settingsViewModel = DependencyProvider.settingsViewModel
        bindViewModel()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDefaultAddress()
        updateCurrentCurrencyLabel()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }


      private func setupView(view: UIView) {
          view.layer.shadowRadius = 4.0
          view.layer.cornerRadius = 10.0
          view.layer.shadowColor = UIColor.black.cgColor
          view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
          view.layer.shadowOpacity = 0.5
      }

      func updateCurrentAddressLabel(with city: String) {
          self.currentAddress.text = city
      }
      
    private func updateCurrentCurrencyLabel() {
        if let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") {
            currentCurrency.text = selectedCurrency
        } else {
            currentCurrency.text = "No Currency Selected"
        }
    }
      private func fetchDefaultAddress() {
          TryAddressNetworkService.shared.getAddresses { result in
              switch result {
              case .success(let addresses):
                  if let defaultAddress = addresses.first(where: { $0.default == true }) {
                      DispatchQueue.main.async {
                          self.updateCurrentAddressLabel(with: defaultAddress.city)
                      }
                  } else {
                      DispatchQueue.main.async {
                          self.updateCurrentAddressLabel(with: "No Default Address")
                      }
                  }
              case .failure(let error):
                  print("Failed to fetch addresses: \(error)")
              }
          }
      }
       

    func bindViewModel() {
        settingsViewModel.bindLogOutStatusViewModelToController = {
            DispatchQueue.main.async {
                self.navigateToSignUp()
            }
        }
        
        settingsViewModel.bindErrorViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.settingsViewModel.errorMessage {
                    self?.showSignOutFailureAlert(title: "Failure", message: "\(errorMessage)", button1Title: "Ok", completion: {})
                }
            }
        }
    }

    func navigateToSignUp() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        print("Print navigateToSignUp")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = sb.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }

    
    func showSignOutFailureAlert(title: String, message: String, button1Title: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button1Title, style: .cancel) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }


      
}
