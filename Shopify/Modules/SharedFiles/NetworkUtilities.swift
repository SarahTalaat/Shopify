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
                    print(decodedData)
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


enum CategoryID: Int {
    case men = 303081423009
    case women = 303081455777
    case kids = 303081488545
    case sale = 303081521313
}

