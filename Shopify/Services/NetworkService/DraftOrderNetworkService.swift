//
//  DraftOrderNetworkService.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 10/06/2024.
//

import Foundation
import Alamofire
class DraftOrderNetworkService {
    let draftOrderId = UserDefaults.standard.string(forKey: Constants.shoppingCartId)
   
    func fetchDraftOrders(completion: @escaping (Swift.Result<OneDraftOrderResponse, Error>) -> Void) {
        if let draftOrderId = draftOrderId, let unwrappedDraftOrderId = Int(draftOrderId) {
            print("Unwrapped draftOrderId: \(unwrappedDraftOrderId)")
            let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/\(unwrappedDraftOrderId).json"
            
            Alamofire.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                    do {
                        let decoder = JSONDecoder()
                        
                        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = jsonResponse["errors"] as? String {
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error])))
                        } else {
                            let draftOrderResponse = try decoder.decode(OneDraftOrderResponse.self, from: data)
                            completion(.success(draftOrderResponse))
                        }
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Network request error: \(error)")
                    completion(.failure(error))
                }
            }
        } else {
            print("draftOrderId is nil")
            // Handle the case where draftOrderId is nil
        }
    }
    func updateDraftOrder(draftOrder: DraftOrderPUT, completion: @escaping (Swift.Result<DraftOrderPUT, Error>) -> Void) {
            let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/\(draftOrderId).json"
            
            let parameters: [String: Any] = [
                "draft_order": [
                    "line_items": draftOrder.line_items.map { [
                        "title": $0.title,
                        "variant_id": $0.variant_id,
                        "variant_title": $0.variant_title,
                        "quantity": $0.quantity,
                        "price": $0.price
                    ]}
                ]
            ]
            
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                switch response.result {
                case .success(let data):
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                    do {
                        let decoder = JSONDecoder()
                        let draftOrderResponse = try decoder.decode([String: DraftOrderPUT].self, from: data)
                        if let draftOrder = draftOrderResponse["draft_order"] {
                            completion(.success(draftOrder))
                        } else {
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                        }
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Network request error: \(error)")
                    completion(.failure(error))
                }
            }
        }
    
}
