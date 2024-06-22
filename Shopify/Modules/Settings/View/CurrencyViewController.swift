//
//  CurrencyViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class CurrencyViewController: UIViewController
{
    
    @IBOutlet weak var currencyTableView: UITableView!
    
    var viewModel = CurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CurrencyTableViewCell", bundle: nil)
        currencyTableView.register(nib, forCellReuseIdentifier: "CurrencyTableViewCell")
        self.title = "Currency"
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        searchCurrency.delegate = self
        currencyTableView.separatorStyle = .none
        currencyTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        viewModel.setDefaultCurrencyIfNeeded(customerId: SharedDataRepository.instance.customerId!)
        viewModel.fetchCurrencies {
            DispatchQueue.main.async {
                self.currencyTableView.reloadData()
            }
        }
    }


       
   
    @IBOutlet weak var searchCurrency: UISearchBar!
    @IBOutlet weak var USDView: UIView!
    
    
    @IBOutlet weak var EGPView: UIView!
    
}
extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        let currency = viewModel.filteredCurrencies[indexPath.row]
        cell.currency.text = currency
        
        if currency == UserDefaults.standard.string(forKey: "selectedCurrency") {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = viewModel.filteredCurrencies[indexPath.row]
        UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
        navigationController?.popViewController(animated: true)
    }
}

extension CurrencyViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredCurrencies = viewModel.currencies
        } else {
            viewModel.filteredCurrencies = viewModel.currencies.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
        currencyTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filteredCurrencies = viewModel.currencies
        currencyTableView.reloadData()
    }
}
