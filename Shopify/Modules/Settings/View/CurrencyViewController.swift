//
//  CurrencyViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class CurrencyViewController: UIViewController,UITableViewDelegate, UITableViewDataSource 
{
    
    @IBOutlet weak var currencyTableView: UITableView!
  
    var exchangeRateApiService = ExchangeRateApiService()
       var currencies: [String] = []
    
    
    override func viewDidLoad() {
            super.viewDidLoad()

            let nib = UINib(nibName: "CurrencyTableViewCell", bundle: nil)
            currencyTableView.register(nib, forCellReuseIdentifier: "CurrencyTableViewCell")
            self.title = "Currency"
            currencyTableView.delegate = self
            currencyTableView.dataSource = self
            currencyTableView.separatorStyle = .none
            currencyTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

            fetchCurrencies()
        }

    func fetchCurrencies() {
        exchangeRateApiService.getLatestRates { result in
            switch result {
            case .success(let response):
                // Get all currencies from the response
                let allCurrencies = Array(response.conversion_rates.keys)
                var selectedCurrencies = ["USD", "EGP"]
                while selectedCurrencies.count < 20 {
                    if let randomCurrency = allCurrencies.randomElement(), !selectedCurrencies.contains(randomCurrency) {
                        selectedCurrencies.append(randomCurrency)
                    }
                }
                self.currencies = selectedCurrencies
                DispatchQueue.main.async {
                    self.currencyTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching currencies: \(error.localizedDescription)")
            }
        }
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return currencies.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
            cell.currency.text = currencies[indexPath.row]
            return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedCurrency = currencies[indexPath.row]
            UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
            navigationController?.popViewController(animated: true)
        }
    
    
    @IBOutlet weak var USDView: UIView!
    
    
    @IBOutlet weak var EGPView: UIView!
    
}
