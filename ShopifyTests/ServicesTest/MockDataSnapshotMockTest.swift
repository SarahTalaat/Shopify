////
////  MockDataSnapshotMockTest.swift
////  ShopifyTests
////
////  Created by Sara Talat on 24/06/2024.
////
//
//import Foundation
//import FirebaseDatabase
//import XCTest
//@testable import Shopify
//
//class MockDataSnapshot: DataSnapshot {
//    private var mockData: [String: Any]
//
//    init(mockData: [String: Any] = [:]) {
//        self.mockData = mockData
//        super.init()
//    }
//
//    override var value: Any? {
//        return mockData
//    }
//
//    override func childSnapshot(forPath childPathString: String) -> DataSnapshot {
//        let childData = mockData[childPathString] as? [String: Any] ?? [:]
//        return MockDataSnapshot(mockData: childData)
//    }
//}
