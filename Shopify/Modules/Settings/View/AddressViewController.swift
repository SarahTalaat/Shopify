//
//  AddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class AddressViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    
    var addresses: [Address] = []
    var defaultAddressId: Int?
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
      }

      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          fetchAddresses()
      }

    func fetchAddresses() {
           TryAddressNetworkService.shared.getAddresses { result in
               switch result {
               case .success(let addresses):
                   self.addresses = addresses
                   DispatchQueue.main.async {
                       self.addressTableView.reloadData()
                   }
                   self.updateDefaultAddressLabel()
               case .failure(let error):
                   print("Failed to fetch addresses: \(error)")
               }
           }
       }
       
       func updateDefaultAddressLabel() {
           if let defaultAddress = addresses.first(where: { $0.default == true }) {
               DispatchQueue.main.async {
                   if let settingsVC = self.navigationController?.viewControllers.first(where: { $0 is SettingsScreenViewController }) as? SettingsScreenViewController {
                       settingsVC.currentAddress.text = defaultAddress.city
                   }
               }
           }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return addresses.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as! addressTableViewCell
           let address = addresses[indexPath.row]
           let isDefault = address.`default` ?? false
           cell.configure(with: address, isDefault: isDefault)
           return cell
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
               let address = addresses[indexPath.row]
               if let addressId = address.id {
                   TryAddressNetworkService.shared.deleteAddress(addressId: addressId) { result in
                       switch result {
                       case .success:
                           self.addresses.remove(at: indexPath.row)
                           DispatchQueue.main.async {
                               self.addressTableView.deleteRows(at: [indexPath], with: .automatic)
                           }
                           self.updateDefaultAddressLabel() // Update default address label after deletion
                       case .failure(let error):
                           print("Failed to delete address: \(error)")
                       }
                   }
               }
           }
       }
    }


