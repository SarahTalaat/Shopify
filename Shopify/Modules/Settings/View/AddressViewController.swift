//
//  AddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit
protocol AddressSelectionDelegate: AnyObject {
    func didSelectAddress(_ address: Address, completion: @escaping () -> Void)
}
class AddressViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    
    
    weak var selectionDelegate: AddressSelectionDelegate?

        var viewModel = AddressViewModel()
        var selectedDefaultAddressId: Int?
    let emptyStateView = UIView()
    let emptyStateImageView = UIImageView()
    @IBAction func addNewAddress(_ sender: UIButton) {

    }
    @IBOutlet weak var addressTableView: UITableView!
    override func viewDidLoad() {
            super.viewDidLoad()
            
            let nib = UINib(nibName: "addressTableViewCell", bundle: nil)
            addressTableView.register(nib, forCellReuseIdentifier: "addressTableViewCell")
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: addressTableView.frame.width, height: 40))
            headerView.backgroundColor = .clear
            addressTableView.tableHeaderView = headerView
            
            addressTableView.delegate = self
            addressTableView.dataSource = self
            addressTableView.separatorStyle = .none
            addressTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            
            viewModel.onAddressesUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.addressTableView.reloadData()
                    self?.updateDefaultAddressLabel()
                }
            }
            
            viewModel.onError = { error in
                print("Error: \(error)")
            }
            
            if let customerId = SharedDataRepository.instance.customerId {
                viewModel.customerId = customerId
            } else {
                print("Error: customerId is nil")
            }
            
            fetchAddresses()
        viewModel.onDefaultAddressDeletionAttempt = { [weak self] in
                self?.showDefaultAddressDeletionAlert()
            }
        setupEmptyStateView()
        toggleEmptyStateView()
        }
    private func setupEmptyStateView() {
        // Configure empty state image view
        emptyStateImageView.image = UIImage(named: "noCart") // Replace with your image name
        emptyStateImageView.contentMode = .scaleAspectFit
        
        // Configure empty state view
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints for image view within empty state view
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100), // Adjust size as needed
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        emptyStateView.isHidden = true // Initially hide the empty state view
        
        addressTableView.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: addressTableView.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: addressTableView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: addressTableView.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: addressTableView.bottomAnchor)
        ])
    }
    private func toggleEmptyStateView() {
        if viewModel.addresses.isEmpty {
                emptyStateView.isHidden = false 
                emptyStateImageView.image = UIImage(named: "NoAddressFound")
            } else {
                emptyStateView.isHidden = true
            }
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchAddresses()
        }
        
        func fetchAddresses() {
            viewModel.fetchAddresses()
        }
        
        func updateDefaultAddressLabel() {
            if let defaultAddress = viewModel.addresses.first(where: { $0.default == true }) {
                DispatchQueue.main.async {
                    if let settingsVC = self.navigationController?.viewControllers.first(where: { $0 is SettingsScreenViewController }) as? SettingsScreenViewController {
                        settingsVC.currentAddress.text = defaultAddress.city
                    }
                }
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.addresses.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard indexPath.row < viewModel.addresses.count else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as! addressTableViewCell
            let address = viewModel.addresses[indexPath.row]
            let isDefault = address.id == viewModel.selectedDefaultAddressId
            cell.configure(with: address, isDefault: isDefault)
            cell.defaultButtonAction = { [weak self] in
                self?.viewModel.setDefaultAddress(at: indexPath)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedAddress = viewModel.addresses[indexPath.row]
                
                // Set the address as default in the ViewModel
                viewModel.setDefaultAddress(at: indexPath)
                
                // Update UI for the selected cell
                if let cell = tableView.cellForRow(at: indexPath) as? addressTableViewCell {
                    let isDefault = selectedAddress.id == viewModel.selectedDefaultAddressId
                    cell.configure(with: selectedAddress, isDefault: isDefault) // Pass isDefault parameter
                }
                
                // Optional: Notify delegate or perform other actions
                selectionDelegate?.didSelectAddress(selectedAddress) {
                    if let paymentViewController = self.navigationController?.viewControllers.first(where: { $0 is PaymentViewController }) as? PaymentViewController {
                        paymentViewController.defaultAddress = selectedAddress
                        paymentViewController.updateAddressLabel()
                        self.navigationController?.popToViewController(paymentViewController, animated: true)
                    }
                }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 20
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }

      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              viewModel.deleteAddress(at: indexPath)
          }
      }
    func showDefaultAddressDeletionAlert() {
        let alert = UIAlertController(title: "Cannot Delete Default Address", message: "The selected address is the default address and cannot be deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
  }
