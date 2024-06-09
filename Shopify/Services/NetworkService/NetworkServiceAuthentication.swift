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
func postCustomerData(customer: CustomerModelRequest, completion: @escaping (Result<CustomersModelResponse, Error>) -> Void) {
     let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/customers.json"

     let parameters: [String: Any] = [
         "customer": [
            "first_name": customer.customer.first_name,
             "email": customer.customer.email,
             "verified_email": customer.customer.verified_email,

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
                             let customersModelResponse = try JSONDecoder().decode(CustomersModelResponse.self, from: data)
                             completion(.success(customersModelResponse))
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
