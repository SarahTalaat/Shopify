////
////  NetworkServiceMockTest.swift
////  ShopifyTests
////
////  Created by Sara Talat on 24/06/2024.
////
//
//
//import Foundation
//import Alamofire
//@testable import Shopify
//
//enum Result<Success, Failure: Error> {
//    case success(Success)
//    case failure(Failure)
//}
//
//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case delete = "DELETE"
//    case put = "PUT"
//}
//
//// Mock network service for testing purposes
//class MockNetworkServiceAuthentication: NetworkServiceAuthenticationProtocol {
//    
//    var mockData: Data?
//    var mockError: Error?
//    
//    func requestFunction<T: Decodable>(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
//        
//        if let error = mockError {
//            completion(.failure(error))
//        } else if let data = mockData {
//            do {
//                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedResponse))
//            } catch {
//                completion(.failure(error))
//            }
//        } else {
//            // Handle case where neither mockData nor mockError is set
//            completion(.failure(NSError(domain: "MockNetworkServiceAuthentication", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock data or error set"])))
//        }
//    }
//}
