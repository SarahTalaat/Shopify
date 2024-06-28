//
//  NetworkUtilities.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//


import Foundation
import Alamofire
class NetworkUtilities{
    
    static let apiKey = "b67adf5ce29253f64d89943674815b12"
    static let shopName = "mad44-alex-ios-team4.myshopify.com"
    static let password = "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"
    
    static func fetchData<T: Decodable>(responseType: T.Type, endpoint: String, completion: @escaping (T?) -> Void) {
        let credentials = "\(apiKey):\(password)"
        guard let credentialData = credentials.data(using: String.Encoding.utf8) else {
            print("Error encoding credentials.")
            completion(nil)
            return
        }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = "https://\(shopName)/admin/api/2022-01/\(endpoint)"
        Alamofire.request(url, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedData)
                   // print(decodedData)
                } catch {
                    print("Error decoding data")
                    print(String(describing: error))
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching data")
                print(String(describing: error))
                completion(nil)
            }
        }
    }
}

extension NetworkUtilities {
    static func postData<T: Encodable>(data: T, endpoint: String, completion: @escaping (Bool) -> Void) {
        let credentials = "\(apiKey):\(password)"
        guard let credentialData = credentials.data(using: String.Encoding.utf8) else {
            print("Error encoding credentials.")
            completion(false)
            return
        }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type": "application/json"
        ]
        
        let url = "https://\(shopName)/admin/api/2022-01/\(endpoint)"
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            Alamofire.request(url, method: .post, parameters: try? JSONSerialization.jsonObject(with: jsonData, options: []) as? Parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success:
                        completion(true)
                    case .failure(let error):
                        print("Error posting data: \(error)")
                        print(String(describing: error))

                        completion(false)
                    }
                }
        } catch {
            print("Error encoding data: \(error)")
            print(String(describing: error))

            completion(false)
        }
    }
}
