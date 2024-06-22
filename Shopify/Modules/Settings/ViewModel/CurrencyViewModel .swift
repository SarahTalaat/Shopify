//
//  CurrencyViewModel .swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 22/06/2024.
//

import Foundation
class CurrencyViewModel {
    private let exchangeRateApiService = ExchangeRateApiService()
    
    var currencies: [String] = []
    var filteredCurrencies: [String] = []
    var selectedCurrency: String?
    
    func fetchCurrencies(completion: @escaping () -> Void) {
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
                completion()
            case .failure(let error):
                print("Error fetching currencies: \(error.localizedDescription)")
            }
        }
    }
    
    func setDefaultCurrencyIfNeeded(customerId: String) {
        let defaultCurrencyKey = "selectedCurrency_\(customerId)"
        let defaultCurrency = UserDefaults.standard.string(forKey: defaultCurrencyKey)
        if defaultCurrency == nil || defaultCurrency != "USD" {
            UserDefaults.standard.set("USD", forKey: defaultCurrencyKey)
        }
    }
}
