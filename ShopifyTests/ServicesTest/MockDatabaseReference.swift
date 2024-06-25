//////
//////  MockDatabaseReference.swift
//////  ShopifyTests
//////
//////  Created by Sara Talat on 24/06/2024.
//////
//
//import Foundation
//import XCTest
//@testable import Shopify
//import FirebaseDatabase
//
//
////protocol DatabaseReferenceProtocol {
////    func child(_ pathString: String) -> DatabaseReferenceProtocol
////    func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void)
////    func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void)
////    func removeValue(completionBlock: @escaping (Error?, DatabaseReference) -> Void)
////    func updateMockData(with value: [String: Any])
////}
//
//
//class MockDatabaseReference: DatabaseReference {
//    var data: [String: Any] = [:]
//    var shouldReturnError = false
//
//    override func child(_ pathString: String) -> DatabaseReference {
//        let childRef = MockDatabaseReference()
//        childRef.data = data // Share the same data dictionary for simplicity
//        return childRef
//    }
//
//    override func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
//        if shouldReturnError {
//            block(MockError.mockError, self)
//        } else {
//            if let valueDict = value as? [String: Any] {
//                updateMockData(with: valueDict)
//            } else if let value = value {
//                data[""] = value // For simplicity, set the value at the root if it's not a dictionary
//            }
//            block(nil, self)
//        }
//    }
//
//    override func removeValue(completionBlock: @escaping (Error?, DatabaseReference) -> Void) {
//        if shouldReturnError {
//            completionBlock(MockError.mockError, self)
//        } else {
//            completionBlock(nil, self)
//            data = [:] // Clear all data upon successful removal
//        }
//    }
//
//    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void, withCancel cancelBlock: ((Error) -> Void)? = nil) {
//        let snapshot = MockDataSnapshot(mockData: data)
//        block(snapshot)
//    }
//
//    // Helper method to update mock data
//    func updateMockData(with value: [String: Any]) {
//        for (key, innerValue) in value {
//            setValueForKeyPath(&data, keyPath: key, value: innerValue)
//        }
//    }
//
//    private func setValueForKeyPath(_ data: inout [String: Any], keyPath: String, value: Any) {
//        var keys = keyPath.components(separatedBy: "/")
//        guard let firstKey = keys.first else { return }
//        keys.remove(at: 0)
//
//        if keys.isEmpty {
//            data[firstKey] = value
//        } else {
//            if data[firstKey] == nil {
//                data[firstKey] = [:]
//            }
//            if var subData = data[firstKey] as? [String: Any] {
//                setValueForKeyPath(&subData, keyPath: keys.joined(separator: "/"), value: value)
//                data[firstKey] = subData
//            }
//        }
//    }
//}
//enum MockError: Error {
//    case mockError
//}
