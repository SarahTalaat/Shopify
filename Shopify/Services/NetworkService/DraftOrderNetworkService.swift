//
//  DraftOrderNetworkService.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 10/06/2024.
//

import Foundation
import Alamofire
class DraftOrderNetworkService {
    func fetchDraftOrders(completion: @escaping (Result<OneDraftOrderResponse, Error>) -> Void) {
        let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/1034452304033.json"
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
    }

    func updateDraftOrder(draftOrder: OneDraftOrderResponse, completion: @escaping (Result<OneDraftOrderResponse, Error>) -> Void) {
            guard let draftOrderId = draftOrder.draftOrder?.id else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Draft order ID is missing"])))
                return
            }

            let url = "https://b67adf5ce29253f64d89943674815b12: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@mad44-alex-ios-team4.myshopify.com/admin/api/2022-01/draft_orders/\(draftOrderId).json"
            
            let parameters: [String: Any] = [
                "draft_order": [
                    "line_items": draftOrder.draftOrder?.lineItems.map { [
                        "id": $0.id as Any,
                        "variant_id": $0.variantId as Any,
                        "product_id": $0.productId as Any,
                        "title": $0.title,
                        "variant_title": $0.variantTitle as Any,
                        "sku": $0.sku as Any,
                        "vendor": $0.vendor as Any,
                        "quantity": $0.quantity,
                        "requires_shipping": $0.requiresShipping as Any,
                        "taxable": $0.taxable as Any,
                        "gift_card": $0.giftCard as Any,
                        "fulfillment_service": $0.fulfillmentService as Any,
                        "grams": $0.grams as Any,
                        "tax_lines": $0.taxLines?.map { [
                            "rate": $0.rate as Any,
                            "title": $0.title as Any,
                            "price": $0.price as Any
                        ]},
                        "applied_discount": $0.appliedDiscount as Any,
                        "name": $0.name as Any,
                        "properties": $0.properties as Any,
                        "custom": $0.custom as Any,
                        "price": $0.price,
                        "admin_graphql_api_id": $0.adminGraphqlApiId as Any
                    ]}
                ]
            ]
            
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                switch response.result {
                case .success(let data):
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                    do {
                        let decoder = JSONDecoder()
                        let draftOrderResponse = try decoder.decode([String: OneDraftOrderResponse].self, from: data)
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
