//
//  TryAddressNetworkService.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 07/06/2024.
//

import Foundation
import Alamofire

protocol NetworkService {
    func fetchAddressData<T: Decodable>(from url: String, responseType: T.Type, completionHandler completion: @escaping (Swift.Result<T, Error>) -> Void)
}
 
class TryAddressNetworkService: NetworkService {
    static let shared = TryAddressNetworkService()
    
    private init() {}
    
    func fetchAddressData<T: Decodable>(from url: String, responseType: T.Type, completionHandler completion: @escaping (Swift.Result<T, Error>) -> Void) {
        Alamofire.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAddresses(completion: @escaping (Swift.Result<[Address], Error>) -> Void) {
     
/*----     https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers/7493076156577/addresses.json?limit
----*/
        fetchAddressData(from: , responseType: AddressListResponse.self) { result in
            switch result {
            case .success(let addressListResponse):
                completion(.success(addressListResponse.addresses))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postNewAddress(address: Address, completion: @escaping (Swift.Result<Address, Error>) -> Void) {
    
        
        /*----
        https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers/7493076156577/addresses.json
 -------*/
        let parameters: [String: Any] = [
            "address": [
                "first_name": address.first_name,
                "address1": address.address1,
                "city": address.city,
                "country": address.country,
                "zip": address.zip
            ]
        ]
 
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
 
            Alamofire.request(request)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let contentType = response.response?.allHeaderFields["Content-Type"] as? String, contentType.contains("application/json") {
                            do {
                                let addressResponse = try JSONDecoder().decode(AddressResponse.self, from: data)
                                completion(.success(addressResponse.customer_address))
                            } catch {
                                print("Error decoding JSON: \(error)")
                                completion(.failure(error))
                            }
                        } else {
                            print("Received non-JSON response: \(String(data: data, encoding: .utf8) ?? "")")
                            let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Unexpected non-JSON response"])
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        print("Request failed: \(error)")
                        completion(.failure(error))
                    }
                }
        } catch {
            print("Error serializing JSON: \(error)")
            completion(.failure(error))
        }
    }
}
