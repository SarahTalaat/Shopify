//
//  AllProductsViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 11/06/2024.
//

import Foundation


class AllProductsViewModel{
    
    var products: [Products] = [] {
        didSet {
            bindAllProducts()
        }
    }
    
    var exchangeRates: [String: Double] = [:]
    var bindAllProducts: (() -> ()) = {}
    
    init() {
        getProducts()
        fetchExchangeRates()
    }
    
    func getProducts() {
        NetworkUtilities.fetchData(responseType: ProductResponse.self, endpoint: "products.json") { product in
            self.products = product?.products ?? []
        }
    }
    private func fetchExchangeRates() {
            let exchangeRateApiService = ExchangeRateApiService()
            exchangeRateApiService.getLatestRates { [weak self] result in
                switch result {
                case .success(let response):
                    self?.exchangeRates = response.conversion_rates
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                }
                self?.bindAllProducts()
            }
        }
     
}
