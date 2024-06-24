//
//  FirebaseAuthServiceTest.swift
//  ShopifyTests
//
//  Created by Sara Talat on 24/06/2024.
//
//import XCTest
//@testable import Shopify
//import FirebaseAuth
//import FirebaseDatabase
//
//class MockAuthService {
////    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
////        <#code#>
////    }
////
////    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
////        <#code#>
////    }
////
////    func deleteProductFromEncodedEmail(encodedEmail: String, productId: String) {
////        <#code#>
////    }
////
////    func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void) {
////        <#code#>
////    }
////
////    func checkProductExists(email: String, productId: String, completion: @escaping (Bool, Error?) -> Void) {
////        <#code#>
////    }
////
////    func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
////        <#code#>
////    }
////
////    func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
////        <#code#>
////    }
////
////    func toggleFavorite(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
////        <#code#>
////    }
////
////    func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
////        <#code#>
////    }
////
////    func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
////        <#code#>
////    }
////
////    func fetchCustomerId(encodedEmail: String, completion: @escaping (String?) -> Void) {
////        <#code#>
////    }
////
////    func fetchFavorites(email: String, completion: @escaping ([String : Bool]) -> Void) {
////        <#code#>
////    }
////
//
//    var shouldSucceedSignIn = true
//    var shouldSucceedSignUp = true
//    var shouldFailEmailVerification = false
//
//    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        if shouldSucceedSignIn {
//            let userModel = UserModel(uid: "mock_uid", email: email)
//            completion(.success(userModel))
//        } else {
//            let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-in failed"])
//            completion(.failure(error))
//        }
//    }
//
//    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
//        // Mock sign out, always succeed
//        completion(.success(()))
//    }
//
//    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        if shouldSucceedSignUp {
//            let userModel = UserModel(uid: "mock_uid", email: email)
//            completion(.success(userModel))
//        } else {
//            let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up failed"])
//            completion(.failure(error))
//        }
//    }
//
//    func checkEmailVerification(for user: User, completion: @escaping (Bool, Error?) -> Void) {
//        if shouldFailEmailVerification {
//            let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email verification failed"])
//            completion(false, error)
//        } else {
//            completion(true, nil)
//        }
//    }
//
//    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String, isSignedIn: String) {
//        // Mock saving customer ID, no implementation needed for testing
//    }
//
//    func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String) {
//        // Mock adding product, no implementation needed for testing
//    }
//}
//
//class FirebaseAuthServiceTests: XCTestCase {
//
//    var authService: MockAuthService!
//    var firebaseAuthService: FirebaseAuthService!
//
//    override func setUp() {
//        super.setUp()
//        authService = MockAuthService()
//        firebaseAuthService = FirebaseAuthService()
//    }
//
//    override func tearDown() {
//        authService = nil
//        firebaseAuthService = nil
//        super.tearDown()
//    }
//
//    func testSignIn_Success() {
//        authService.shouldSucceedSignIn = true
//
//        firebaseAuthService.signIn(email: "test@example.com", password: "password") { result in
//            switch result {
//            case .success(let userModel):
//                XCTAssertEqual(userModel.uid, "mock_uid")
//                XCTAssertEqual(userModel.email, "test@example.com")
//            case .failure(let error):
//                XCTFail("Sign in should succeed, but failed with error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func testSignIn_Failure() {
//        authService.shouldSucceedSignIn = false
//
//        firebaseAuthService.signIn(email: "test@example.com", password: "password") { result in
//            switch result {
//            case .success:
//                XCTFail("Sign in should fail, but succeeded")
//            case .failure(let error):
//                XCTAssertNotNil(error)
//                XCTAssertEqual(error.localizedDescription, "Mock sign-in failed")
//            }
//        }
//    }
//
//    func testSignUp_Success() {
//        authService.shouldSucceedSignUp = true
//
//        firebaseAuthService.signUp(email: "test@example.com", password: "password") { result in
//            switch result {
//            case .success(let userModel):
//                XCTAssertEqual(userModel.uid, "mock_uid")
//                XCTAssertEqual(userModel.email, "test@example.com")
//            case .failure(let error):
//                XCTFail("Sign up should succeed, but failed with error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func testSignUp_Failure() {
//        authService.shouldSucceedSignUp = false
//
//        firebaseAuthService.signUp(email: "test@example.com", password: "password") { result in
//            switch result {
//            case .success:
//                XCTFail("Sign up should fail, but succeeded")
//            case .failure(let error):
//                XCTAssertNotNil(error)
//                XCTAssertEqual(error.localizedDescription, "Mock sign-up failed")
//            }
//        }
//    }
//
//    func testCheckEmailVerification_Success() {
//        authService.shouldFailEmailVerification = false
//
//        firebaseAuthService.checkEmailVerification(for: User()) { isVerified, error in
//            XCTAssertTrue(isVerified)
//            XCTAssertNil(error)
//        }
//    }
//
//    func testCheckEmailVerification_Failure() {
//        authService.shouldFailEmailVerification = true
//
//        firebaseAuthService.checkEmailVerification(for: User()) { isVerified, error in
//            XCTAssertFalse(isVerified)
//            XCTAssertNotNil(error)
//            XCTAssertEqual(error?.localizedDescription, "Email verification failed")
//        }
//    }
//}





import XCTest
@testable import Shopify // Replace with your actual module name
import FirebaseAuth
import FirebaseDatabase

class MockAuthService: AuthServiceProtocol {
    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void) {
        <#code#>
    }
    
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
        <#code#>
    }
    
    func deleteProductFromEncodedEmail(encodedEmail: String, productId: String) {
        <#code#>
    }
    
    func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void) {
        <#code#>
    }
    
    func checkProductExists(email: String, productId: String, completion: @escaping (Bool, Error?) -> Void) {
        <#code#>
    }
    
    func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
        <#code#>
    }
    
    func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
        <#code#>
    }
    
    func toggleFavorite(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
        <#code#>
    }
    
    func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
        <#code#>
    }
    
    func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
        <#code#>
    }
    
    func fetchCustomerId(encodedEmail: String, completion: @escaping (String?) -> Void) {
        <#code#>
    }
    
    func fetchFavorites(email: String, completion: @escaping ([String : Bool]) -> Void) {
        <#code#>
    }
    

    var shouldSucceedSignIn = true
    var shouldSucceedSignUp = true
    var shouldFailEmailVerification = false

    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if shouldSucceedSignIn {
            let userModel = UserModel(uid: "mock_uid", email: email)
            completion(.success(userModel))
        } else {
            let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-in failed"])
            completion(.failure(error))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        // Mock sign out, always succeed
        completion(.success(()))
    }

    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if shouldSucceedSignUp {
            let userModel = UserModel(uid: "mock_uid", email: email)
            completion(.success(userModel))
        } else {
            let error = NSError(domain: "MockAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up failed"])
            completion(.failure(error))
        }
    }

//    func checkEmailVerification(for user: UserInfo, completion: @escaping (Bool, Error?) -> Void) {
//        user.reload { error in
//            if let error = error {
//                completion(false, error)
//            } else {
//                completion(user.isEmailVerified, nil)
//            }
//        }
//    }

    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String, isSignedIn: String) {
        // Mock saving customer ID, no implementation needed for testing
    }

    func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String) {
        // Mock adding product, no implementation needed for testing
    }
}




class FirebaseAuthServiceTests: XCTestCase {

    var authService: MockAuthService!
    var firebaseAuthService: FirebaseAuthService!

    override func setUp() {
        super.setUp()
        authService = MockAuthService()
        firebaseAuthService = FirebaseAuthService()
    }

    override func tearDown() {
        authService = nil
        firebaseAuthService = nil
        super.tearDown()
    }

    func testSignIn_Success() {
        authService.shouldSucceedSignIn = true

        firebaseAuthService.signIn(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let userModel):
                XCTAssertEqual(userModel.uid, "mock_uid")
                XCTAssertEqual(userModel.email, "test@example.com")
            case .failure(let error):
                XCTFail("Sign in should succeed, but failed with error: \(error.localizedDescription)")
            }
        }
    }

    func testSignIn_Failure() {
        authService.shouldSucceedSignIn = false

        firebaseAuthService.signIn(email: "test@example.com", password: "password") { result in
            switch result {
            case .success:
                XCTFail("Sign in should fail, but succeeded")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Mock sign-in failed")
            }
        }
    }

    func testSignUp_Success() {
        authService.shouldSucceedSignUp = true

        firebaseAuthService.signUp(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let userModel):
                XCTAssertEqual(userModel.uid, "mock_uid")
                XCTAssertEqual(userModel.email, "test@example.com")
            case .failure(let error):
                XCTFail("Sign up should succeed, but failed with error: \(error.localizedDescription)")
            }
        }
    }

    func testSignUp_Failure() {
        authService.shouldSucceedSignUp = false

        firebaseAuthService.signUp(email: "test@example.com", password: "password") { result in
            switch result {
            case .success:
                XCTFail("Sign up should fail, but succeeded")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Mock sign-up failed")
            }
        }
    }
    
    func testCheckEmailVerification_Success() {
//        let mockUser = MockUser(uid: "mock_uid", email: "test@example.com", isEmailVerified: true)
//        firebaseAuthService.checkEmailVerification(for: mockUser) { isVerified, error in
//            XCTAssertTrue(isVerified)
//            XCTAssertNil(error)
//        }
    }

    func testCheckEmailVerification_Failure() {
//        let mockUser = MockUser(uid: "mock_uid", email: "test@example.com", isEmailVerified: false)
//        firebaseAuthService.checkEmailVerification(for: mockUser) { isVerified, error in
//            XCTAssertFalse(isVerified)
//            XCTAssertNotNil(error)
//            XCTAssertEqual(error?.localizedDescription, "Email verification failed")
//        }
    }
}
//
//
//protocol UserInfo {
//    var uid: String { get }
//    var email: String? { get }
//    var isEmailVerified: Bool { get }
//    func reload(completion: ((Error?) -> Void)?)
//}
//
//
//class FirebaseUserAdapter: UserInfo {
//    private let firebaseUser: FirebaseAuth.User
//
//    init(firebaseUser: FirebaseAuth.User) {
//        self.firebaseUser = firebaseUser
//    }
//
//    var uid: String {
//        return firebaseUser.uid
//    }
//
//    var email: String? {
//        return firebaseUser.email
//    }
//
//    var isEmailVerified: Bool {
//        return firebaseUser.isEmailVerified
//    }
//
//    func reload(completion: ((Error?) -> Void)?) {
//        firebaseUser.reload { error in
//            completion?(error)
//        }
//    }
//}
//
//
//class MockUser: UserInfo {
//    var uid: String
//    var email: String?
//    var isEmailVerified: Bool
//
//    init(uid: String, email: String?, isEmailVerified: Bool) {
//        self.uid = uid
//        self.email = email
//        self.isEmailVerified = isEmailVerified
//    }
//
//    func reload(completion: ((Error?) -> Void)?) {
//        // Implement reload logic here if necessary
//        completion?(nil) // Simulate completion with no error
//    }
//}
//
//
