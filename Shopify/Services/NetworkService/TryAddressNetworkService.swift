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
    let customerId = SharedDataRepository.instance.customerId
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
    
    func getAddresses(completion: @escaping (Result<[Address], Error>) -> Void) {
        guard let customerId = customerId else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is missing"])
            completion(.failure(error))
            return
        }

        let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers/\(customerId)/addresses.json?limit"
        fetchAddressData(from: url, responseType: AddressListResponse.self) { result in
            switch result {
            case .success(let addressListResponse):
                completion(.success(addressListResponse.addresses))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func postNewAddress(address: Address, completion: @escaping (Result<Address, Error>) -> Void) {
//        guard let customerId = customerId else {
//            print("Customer ID is nil")
//            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is missing"])
//            completion(.failure(error))
//            return
//        }
//        
//        let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers/\(customerId)/addresses.json"
//        
//        let parameters: [String: Any] = [
//            "address": [
//                "first_name": address.first_name,
//                "address1": address.address1,
//                "city": address.city,
//                "country": address.country,
//                "zip": address.zip
//            ]
//        ]
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//            var request = URLRequest(url: URL(string: url)!)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            request.httpBody = jsonData
//
//            Alamofire.request(request)
//                .validate()
//                .responseData { response in
//                    switch response.result {
//                    case .success(let data):
//                        do {
//                            let addressResponse = try JSONDecoder().decode(AddressResponse.self, from: data)
//                            completion(.success(addressResponse.customer_address))
//                        } catch {
//                            print("Error decoding JSON: \(error)")
//                            completion(.failure(error))
//                        }
//                    case .failure(let error):
//                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                            print("Server response: \(responseString)")
//                        }
//                        print("Request failed: \(error)")
//                        completion(.failure(error))
//                    }
//                }
//        } catch {
//            print("Error serializing JSON: \(error)")
//            completion(.failure(error))
//        }
//    }
    func deleteAddress(addressId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let customerId = customerId else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is missing"])
            completion(.failure(error))
            return
        }

        let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers/\(customerId)/addresses/\(addressId).json"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        
        Alamofire.request(request).validate().response { response in
            if let error = response.error {
                if let data = response.data,
                   let responseString = String(data: data, encoding: .utf8) {
                    print("Server response: \(responseString)")
                }
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func updateAddress(addressId: Int, isDefault: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let customerId = customerId else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is missing"])
            completion(.failure(error))
            return
        }
        
        let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers/\(customerId)/addresses/\(addressId).json"
        
        let parameters: [String: Any] = [
            "address": [
                "default": isDefault
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            
            Alamofire.request(request).validate().response { response in
                if let error = response.error {
                    if let data = response.data,
                       let responseString = String(data: data, encoding: .utf8) {
                        print("Server response: \(responseString)")
                    }
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

}
