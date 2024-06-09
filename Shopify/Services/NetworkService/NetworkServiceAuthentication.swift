//
//  NetworkServiceAuthentication.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.


import Foundation
import Alamofire

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}


class NetworkServiceAuthentication: NetworkServiceAuthenticationProtocol{

   
    func postCustomerData<T: Decodable>(apiConfig: APIConfig, customer: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        print("Starting postCustomerData function")
        print("")
        
        let urlString = apiConfig.url
        print("Constructed URL: \(urlString)")
        print("")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: customer, options: .prettyPrinted)
            print("JSON data serialization succeeded")
            print("")
            
            guard let url = URL(string: urlString) else {
                let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                print("Error: Invalid URL")
                print("")
                completion(.failure(error))
                return
            }
            print("URL is valid: \(url)")
            print("")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            print("Starting Alamofire request")
            print("")
            Alamofire.request(request)
                .validate()
                .responseData { response in
                    print("Received response")
                    print("")
                    switch response.result {
                    case .success(let data):
                        print("Request succeeded, received data")
                        print("")
                        if let contentType = response.response?.allHeaderFields["Content-Type"] as? String, contentType.contains("application/json") {
                            do {
                                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                                print("JSON decoding succeeded")
                                print("")
                                completion(.success(decodedResponse))
                            } catch let decodingError {
                                print("Error decoding JSON: \(decodingError.localizedDescription)")
                                print("")
                                completion(.failure(decodingError))
                            }
                        } else {
                            let responseString = String(data: data, encoding: .utf8) ?? ""
                            print("Received non-JSON response: \(responseString)")
                            print("")
                            let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Unexpected non-JSON response"])
                            completion(.failure(error))
                        }
                    case .failure(let requestError):
                        print("Request failed: \(requestError.localizedDescription)")
                        print("")
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response data: \(responseString)")
                            print("")
                        }
                        completion(.failure(requestError))
                    }
                }
        } catch let serializationError {
            print("Error serializing JSON: \(serializationError.localizedDescription)")
            print("")
            completion(.failure(serializationError))
        }
    }

    
}

//    func postCustomerData(customer:[String:Any], completion: @escaping (Result<CustomersModelResponse, Error>) -> Void) {
//     let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers.json"
//
//     do {
//         let jsonData = try JSONSerialization.data(withJSONObject: customer, options: .prettyPrinted)
//         var request = URLRequest(url: URL(string: url)!)
//         request.httpMethod = "POST"
//         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//         request.httpBody = jsonData
//
//         Alamofire.request(request)
//             .validate()
//             .responseData { response in
//                 switch response.result {
//                 case .success(let data):
//                     if let contentType = response.response?.allHeaderFields["Content-Type"] as? String, contentType.contains("application/json") {
//                         do {
//                             let customersModelResponse = try JSONDecoder().decode(CustomersModelResponse.self, from: data)
//                             completion(.success(customersModelResponse))
//                         } catch {
//                             print("Error decoding JSON: \(error)")
//                             completion(.failure(error))
//                         }
//                     } else {
//                         print("Received non-JSON response: \(String(data: data, encoding: .utf8) ?? "")")
//                         let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Unexpected non-JSON response"])
//                         completion(.failure(error))
//                     }
//                 case .failure(let error):
//                     print("Request failed: \(error)")
//                     completion(.failure(error))
//                 }
//             }
//     } catch {
//         print("Error serializing JSON: \(error)")
//         completion(.failure(error))
//     }
// }
