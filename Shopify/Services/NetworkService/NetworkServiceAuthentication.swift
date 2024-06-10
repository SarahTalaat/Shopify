//
//  NetworkServiceAuthentication.swift
//  Shopify
//
//  Created by Sara Talat on 08/06/2024.

/*
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 request.setValue("application/json", forHTTPHeaderField: "Accept")
 */
import Foundation
import Alamofire

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more methods as needed
}

class NetworkServiceAuthentication: NetworkServiceAuthenticationProtocol {
    
    func requestFunction<T: Decodable>(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        
        if let data = Constants.credentials.data(using: .utf8) {
            let base64Credentials = data.base64EncodedString()
            var headers: HTTPHeaders = [
                "Authorization": "Basic \(base64Credentials)",
            ]
            
            // Set Content-Type and Accept headers for both POST and GET requests
            headers["Content-Type"] = "application/json"
            headers["Accept"] = "application/json"
            
            var request: DataRequest
            switch method {
            case .get:
                request = Alamofire.request(urlString, method: .get, parameters: model, encoding: URLEncoding.default, headers: headers)
            case .post:
                request = Alamofire.request(urlString, method: .post, parameters: model, encoding: JSONEncoding.default, headers: headers)
            }
            
            request.validate().responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    


    
}


//
//class NetworkServiceAuthentication: NetworkServiceAuthenticationProtocol{
//
//        func postCustomerData<T: Decodable>(apiConfig: APIConfig, customer: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
//            print("Starting postCustomerData function")
//
//            let urlString = apiConfig.url
//            print("Constructed URL: \(urlString)")
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: customer, options: .prettyPrinted)
//                print("JSON data serialization succeeded")
//
//                guard let url = URL(string: urlString) else {
//                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//                    print("Error: Invalid URL")
//                    completion(.failure(error))
//                    return
//                }
//                print("URL is valid: \(url)")
//
//                var request = URLRequest(url: url)
//                request.httpMethod = "POST"
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.setValue(Constants.adminApiAccessToken, forHTTPHeaderField: "X-Shopify-Access-Token")
//                request.httpBody = jsonData
//
//                print("Starting Alamofire request")
//                Alamofire.request(request)
//                    .validate()
//                    .responseData { response in
//                        print("Received response")
//                        switch response.result {
//                        case .success(let data):
//                            print("Request succeeded, received data")
//                            if let contentType = response.response?.allHeaderFields["Content-Type"] as? String, contentType.contains("application/json") {
//                                do {
//                                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
//                                    print("JSON decoding succeeded")
//                                    completion(.success(decodedResponse))
//                                } catch let decodingError {
//                                    print("Error decoding JSON: \(decodingError.localizedDescription)")
//                                    completion(.failure(decodingError))
//                                }
//                            } else {
//                                let responseString = String(data: data, encoding: .utf8) ?? ""
//                                print("Received non-JSON response: \(responseString)")
//                                let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Unexpected non-JSON response"])
//                                completion(.failure(error))
//                            }
//                        case .failure(let requestError):
//                            print("Request failed: \(requestError.localizedDescription)")
//                            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                                print("Response data: \(responseString)")
//                            }
//                            completion(.failure(requestError))
//                        }
//                    }
//            } catch let serializationError {
//                print("Error serializing JSON: \(serializationError.localizedDescription)")
//                completion(.failure(serializationError))
//            }
//
//
//
//        }
//
//}
//-----------------------------------------
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



//     func requestFunction<T: Decodable>(urlString: String, method: HTTPMethod, model: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
//           guard let data = Constants.credentials.data(using: .utf8) else { return }
//           let base64Credentials = data.base64EncodedString()
//           let headers: HTTPHeaders = [
//               "Authorization": "Basic \(base64Credentials)",
//               "Accept": "application/json"
//           ]
//
//           print("network data: \(data)")
//
//           Alamofire.request(urlString, method: method, parameters: model, encoding: JSONEncoding.default, headers: headers)
//               .validate()
//               .responseData { response in
//                   print("network response \(response)")
//                   switch response.result {
//                   case .success(let data):
//                       do {
//                           let decodedResponse = try JSONDecoder().decode(T.self, from: data)
//                           completion(.success(decodedResponse))
//                       } catch {
//                           print("network success catch: \(data)")
//                           completion(.failure(error))
//                       }
//                   case .failure(let error):
//                       print("network failure \(data)")
//                       completion(.failure(error))
//                   }
//               }
//       }
   
//       func postFunction<T: Decodable>(urlString: String, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
//           requestFunction(urlString: urlString, method: .post, model: model, completion: completion)
//       }
//
//       func getFunction<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
//           requestFunction(urlString: urlString, method: .get, completion: completion)
//       }

