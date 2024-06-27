//////
//////  SignInVMTest.swift
//////  ShopifyTests
//////
//////  Created by Sara Talat on 27/06/2024.
//////
////
//import Foundation
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//import XCTest
//@testable import Shopify
//
//
//
//
//
//
//
//class MockFirebaseAuthService2: FirebaseAuthService {
//
//    static var instance2 = MockFirebaseAuthService2()
//    private init() {
//        super.init(forTesting: true)
//    }
//
//    var signInCompletionHandler: ((String, String, @escaping (Result<UserModel, Error>) -> Void) -> Void) = { _, _, _ in }
//    var signOutCompletionHandler: ((@escaping (Result<Void, Error>) -> Void) -> Void) = { _ in }
//    var signUpCompletionHandler: ((String, String, @escaping (Result<UserModel, Error>) -> Void) -> Void) = { _, _, _ in }
//    var checkEmailVerificationCompletionHandler: ((User, @escaping (Bool, Error?) -> Void) -> Void) = { _, _ in }
//    var saveCustomerIdCompletionHandler: ((String, String, String, String, String, String, String, String, String) -> Void)?
//
//    var addProductToEncodedEmailCompletionHandler: ((String, String, String, String, String) -> Void) = { _, _, _, _, _ in }
//    var fetchCustomerIdCompletionHandler: ((String, @escaping (String?) -> Void) -> Void) = { _, _ in }
//    var toggleFavoriteCompletionHandler: ((String, String, String, String, String, Bool, @escaping (Error?) -> Void) -> Void) = { _, _, _, _, _, _, _ in }
//    var fetchFavoritesCompletionHandler: ((String, @escaping ([String: Bool]) -> Void) -> Void) = { _, _ in }
//    var checkProductExistsCompletionHandler: ((String, String, @escaping (Bool, Error?) -> Void) -> Void) = { _, _, _ in }
//    var checkEmailSignInStatusCompletionHandler: ((String, @escaping (Bool?) -> Void) -> Void) = { _, _ in }
//    var updateSignInStatusCompletionHandler: ((String, String, @escaping (Bool) -> Void) -> Void) = { email, _, _ in
//
//        print("\(email)")
//    }
//    var setShoppingCartIdCompletionHandler: ((String, String, @escaping (Error?) -> Void) -> Void) = { _, _, _ in }
//    var getShoppingCartIdCompletionHandler: ((String, @escaping (String?, Error?) -> Void) -> Void) = { _, _ in }
//    var fetchCustomerDataFromRealTimeDatabaseCompletionHandler: ((String, @escaping (CustomerData?) -> Void) -> Void) = { _, _ in }
//    var isEmailTakenCompletionHandler: ((String, @escaping (Bool) -> Void) -> Void) = { _, _ in }
//
//    override func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        signInCompletionHandler(email, password, completion)
//    }
//
//    override func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
//        signOutCompletionHandler(completion)
//    }
//
//    override func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        signUpCompletionHandler(email, password, completion)
//    }
//
//    override func checkEmailVerification(for user: User, completion: @escaping (Bool, Error?) -> Void) {
//        checkEmailVerificationCompletionHandler(user, completion)
//    }
//
//    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String) {
//        saveCustomerIdCompletionHandler?(name, email, id, favouriteId, shoppingCartId, productId, productTitle, productVendor, productImage)
//    }
//
//    override func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String) {
//        addProductToEncodedEmailCompletionHandler(email, productId, productTitle, productVendor, productImage)
//    }
//
//    override func fetchCustomerId(encodedEmail: String, completion: @escaping (String?) -> Void) {
//        fetchCustomerIdCompletionHandler(encodedEmail, completion)
//    }
//
//    override func toggleFavorite(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
//        toggleFavoriteCompletionHandler(email, productId, productTitle, productVendor, productImage, isFavorite, completion)
//    }
//
//    override func fetchFavorites(email: String, completion: @escaping ([String: Bool]) -> Void) {
//        fetchFavoritesCompletionHandler(email, completion)
//    }
//
//    override func checkProductExists(email: String, productId: String, completion: @escaping (Bool, Error?) -> Void) {
//        checkProductExistsCompletionHandler(email, productId, completion)
//    }
//
//    override func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void) {
//        checkEmailSignInStatusCompletionHandler(email,completion)
//    }
//
//    func updateSignInStatus(email: String, status: String, completion: @escaping (Bool) -> Void) {
//        updateSignInStatusCompletionHandler(email, status, completion)
//    }
//
//    override func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void) {
//        setShoppingCartIdCompletionHandler(email, shoppingCartId, completion)
//    }
//
//    override func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void) {
//        getShoppingCartIdCompletionHandler(email, completion)
//    }
//
//    func fetchCustomerDataFromRealTimeDatabase(email: String, completion: @escaping (CustomerData?) -> Void) {
//        fetchCustomerDataFromRealTimeDatabaseCompletionHandler(email, completion)
//    }
//
//    override func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
//        isEmailTakenCompletionHandler(email, completion)
//    }
//}
//
//import XCTest
//
//class SignInViewModelTests: XCTestCase {
//
//    var signInViewModel: SignInViewModel!
//    var mockFirebaseAuthService: MockFirebaseAuthService2!
//
//    override func setUp() {
//        super.setUp()
//        mockFirebaseAuthService = MockFirebaseAuthService2.instance2
//        signInViewModel = SignInViewModel()
//        FirebaseAuthService.instance = mockFirebaseAuthService
//    }
//
////    func testSignIn() {
////        // Arrange
////        let email = "test@example.com"
////        let password = "password"
////        let user = UserModel(uid: "uid", email: email)
////
////        // Act
////        signInViewModel.signIn(email: email, password: password)
////
////        // Assert
////        XCTAssertNotNil(signInViewModel.user)
////    //    XCTAssertEqual(signInViewModel.user, user)
////    }
//    
//    
//
//    func testUpdateSignInStatus() {
//        // Arrange
//        let email = "test@example.com"
//
//        // Act
//        signInViewModel.updateSignInStatus(email: email)
//
//        // Assert
//        // Verify that the updateSignInStatus method was called on the mockFirebaseAuthService
//        XCTAssertNotNil(mockFirebaseAuthService.updateSignInStatusCompletionHandler)
//    }
//
//    func testCheckEmailSignInStatus() {
//        // Arrange
//        let email = "test@example.com"
//        let isSignedIn = true
//
//        // Act
//        signInViewModel.checkEmailSignInStatus(email: email)
//
//        print("GGG \(mockFirebaseAuthService.checkEmailSignInStatusCompletionHandler)")
//        // Assert
//        XCTAssertNotNil(mockFirebaseAuthService.checkEmailSignInStatusCompletionHandler)
//    }
//
//    func testFetchCustomerID() {
//        // Arrange
//        let email = "test@example.com"
//        let customerData = CustomerData(customerId: "customerId", name: "name", email: email, favouriteId: "favouriteId", shoppingCartId: "shoppingCartId")
//
//        // Act
//        signInViewModel.fetchCustomerID()
//
//        // Assert
//
//        XCTAssertNotNil(mockFirebaseAuthService.fetchCustomerDataFromRealTimeDatabaseCompletionHandler)
//    }
//
//    func testPostDraftOrderForShoppingCart() {
//        // Arrange
//        let urlString = "https://example.com/draft_orders"
//        let parameters: [String: Any] = ["draft_order": ["line_items": [["variant_id": 44382096457889, "quantity": 1]]]]
//        let name = "Name"
//        let email = "test@example.com"
//
//        // Act
//        signInViewModel.postDraftOrderForShoppingCart(urlString: urlString, parameters: parameters, name: name, email: email) { response in
//            // Assert
//            XCTAssertNotNil(response)
//        }
//    }
//
//    func testSetDraftOrderId() {
//        // Arrange
//        let email = "test@example.com"
//        let shoppingCartID = "shoppingCartId"
//
//        // Act
//        signInViewModel.setDraftOrderId(email: email, shoppingCartID: shoppingCartID)
//
//        // Assert
//        XCTAssertNotNil(mockFirebaseAuthService.setShoppingCartIdCompletionHandler)
//    }
//
//    func testGetDraftOrderID() {
//        // Arrange
//        let email = "test@example.com"
//
//        // Act
//        signInViewModel.getDraftOrderID(email: email)
//
//        // Assert
//        // Verify that the getShoppingCartId method was called on the mockFirebaseAuthService
//        XCTAssertNotNil(mockFirebaseAuthService.getShoppingCartIdCompletionHandler)
//    }
//
//    func testAddValueToUserDefaults() {
//        // Arrange
//        let value = "value"
//        let key = "key"
//
//        // Act
//        signInViewModel.addValueToUserDefaults(value: value, forKey: key)
//
//        // Assert
//        // Verify that the value was added to UserDefaults
//        XCTAssertEqual(UserDefaults.standard.value(forKey: key) as? String, value)
//    }
//
//    func testDraftOrderDummyModel1() {
//        // Act
//        let draftOrder = signInViewModel.draftOrderDummyModel1()
//
//        // Assert
//        XCTAssertNotNil(draftOrder)
//    }
//
//    func testDraftOrderDummyModel2() {
//        // Act
//        let draftOrder = signInViewModel.draftOrderDummyModel2()
//
//        // Assert
//        XCTAssertNotNil(draftOrder)
//    }
//
//    func testGetUserDraftOrderId() {
//        // Arrange
//        let email = "test@example.com"
//
//        // Act
//        signInViewModel.getUserDraftOrderId()
//
//        // Assert
//        // Verify that the getDraftOrderID method was called
//        XCTAssertNotNil(signInViewModel.getDraftOrderID(email: email))
//    }
//}
