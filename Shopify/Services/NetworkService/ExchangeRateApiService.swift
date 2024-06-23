//
//  ExchangeRateApiService.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 14/06/2024.
//

import Foundation
class ExchangeRateApiService {
    private let apiKey = "b1b362324215ea59af2d3263"
    private let baseUrl = "https://v6.exchangerate-api.com/v6/"
    
    func getLatestRates(completion: @escaping (Result<ExchangeRatesResponse, Error>) -> Void) {
        let urlString = "\(baseUrl)\(apiKey)/latest/USD"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let exchangeRatesResponse = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
                completion(.success(exchangeRatesResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func getAllLatestRates(completion: @escaping (Result<ExchangeRatesResponse, Error>) -> Void) {
        let urlString = "\(baseUrl)\(apiKey)/latest/ALL"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let exchangeRatesResponse = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
                completion(.success(exchangeRatesResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
