//
//  CurrencyViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class CurrencyViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{
    
    @IBOutlet weak var currencyTableView: UITableView!
  
    var exchangeRateApiService = ExchangeRateApiService()
       var currencies: [String] = []
       var filteredCurrencies: [String] = []

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

           setDefaultCurrencyIfNeeded()
           fetchCurrencies()
       }

       func fetchCurrencies() {
           exchangeRateApiService.getLatestRates { result in
               switch result {
               case .success(let response):
                   let allCurrencies = Array(response.conversion_rates.keys)
                   var selectedCurrencies = ["USD", "EGP"]
                   while selectedCurrencies.count < 20 {
                       if let randomCurrency = allCurrencies.randomElement(), !selectedCurrencies.contains(randomCurrency) {
                           selectedCurrencies.append(randomCurrency)
                       }
                   }
                   self.currencies = selectedCurrencies
                   self.filteredCurrencies = selectedCurrencies
                   DispatchQueue.main.async {
                       self.currencyTableView.reloadData()
                   }
               case .failure(let error):
                   print("Error fetching currencies: \(error.localizedDescription)")
               }
           }
       }

    func setDefaultCurrencyIfNeeded() {
        let customerId = SharedDataRepository.instance.customerId
        let defaultCurrencyKey = "selectedCurrency_\(customerId)"
        let defaultCurrency = UserDefaults.standard.string(forKey: defaultCurrencyKey)
        print("Default currency before setting for customer \(customerId): \(defaultCurrency ?? "not set")")
        if defaultCurrency == nil || defaultCurrency != "USD" {
            UserDefaults.standard.set("USD", forKey: defaultCurrencyKey)
            print("Default currency set to USD for customer \(customerId)")
        }
    }

       // MARK: - Table View Methods

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredCurrencies.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
           let currency = filteredCurrencies[indexPath.row]
           cell.currency.text = currency

           // Highlight the default currency
           if currency == UserDefaults.standard.string(forKey: "selectedCurrency") {
               cell.backgroundColor = UIColor.lightGray // Highlight color
           } else {
               cell.backgroundColor = UIColor.white
           }

           return cell
       }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedCurrency = filteredCurrencies[indexPath.row]
           UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
           navigationController?.popViewController(animated: true)
       }

       // MARK: - Search Bar Delegate Methods

       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredCurrencies = currencies
           } else {
               filteredCurrencies = currencies.filter { $0.localizedCaseInsensitiveContains(searchText) }
           }
           currencyTableView.reloadData()
       }

       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = ""
           searchBar.resignFirstResponder()
           filteredCurrencies = currencies
           currencyTableView.reloadData()
       }
   
    @IBOutlet weak var searchCurrency: UISearchBar!
    @IBOutlet weak var USDView: UIView!
    
    
    @IBOutlet weak var EGPView: UIView!
    
}
