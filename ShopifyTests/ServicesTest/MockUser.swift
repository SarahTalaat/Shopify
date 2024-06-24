////
////  MockUser.swift
////  ShopifyTests
////
////  Created by Sara Talat on 24/06/2024.
////
//
//import Foundation
//
//import FirebaseAuth
//
//protocol UserProtocol {
//    var uid: String { get }
//    var email: String? { get }
//    var isEmailVerified: Bool { get }
//
//    func sendEmailVerification(completion: ((Error?) -> Void)?)
//    func reload(completion: ((Error?) -> Void)?)
//}
//
//extension MockUser: UserProtocol {}
//
//class MockUser {
//    var uid: String = "testUid"
//    var email: String? = "test@example.com"
//    var isEmailVerified: Bool = true
//
//    func sendEmailVerification(completion: ((Error?) -> Void)? = nil) {
//        completion?(nil)
//    }
//
//    func reload(completion: ((Error?) -> Void)? = nil) {
//        completion?(nil)
//    }
//}

