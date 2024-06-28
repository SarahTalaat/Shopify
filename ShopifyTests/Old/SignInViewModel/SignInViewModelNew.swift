//
//
//import XCTest
//@testable import Shopify
//class SignInViewModelTests: XCTestCase {
//    var viewModel: SignInViewModel!
//    var mockAuthService: MockAuthService!
//    var mockNetworkService: NetworkServiceMock!
//
//    override func setUp() {
//        super.setUp()
//        viewModel = SignInViewModel()
//        mockAuthService = MockAuthService()
//        mockNetworkService = NetworkServiceMock()
//
//    }
//
//    func testSignInSuccess() {
//        // Set up mock data
//        let email = "test@example.com"
//        let password = "password"
//        let user = UserModel(uid: "mocked_uid", email: email)
//        mockAuthService.signInResult = .success(user)
//
//        // Call the signIn method
//        viewModel.signIn(email: email, password: password)
//
//        // Verify the user is set
//        XCTAssertNotNil(viewModel.user)
//        XCTAssertEqual(viewModel.user?.uid, user.uid)
//        XCTAssertEqual(viewModel.user?.email, email)
//    }
//
//    func testSignInFailure() {
//        // Set up mock data
//        let email = "test@example.com"
//        let password = "password"
//        let error = NSError(domain: "com.example.error", code: 0, userInfo: nil)
//        mockAuthService.signInResult = .failure(error)
//
//        // Call the signIn method
//        viewModel.signIn(email: email, password: password)
//
//        // Verify the error message is set
//        XCTAssertNotNil(viewModel.errorMessage)
//        XCTAssertEqual(viewModel.errorMessage, "An error occurred. Please try again later.")
//    }
//
//    func testUpdateSignInStatus() {
//        // Set up mock data
//        let email = "test@example.com"
//        mockAuthService.signInResult = .success(true)
//
//        // Call the updateSignInStatus method
//        viewModel.updateSignInStatus(email: email)
//
//        // Verify the sign-in status is updated
//        XCTAssertTrue(SharedDataRepository.instance.isSignedIn)
//    }
//
//    func testCheckEmailSignInStatus() {
//        // Set up mock data
//        let email = "test@example.com"
//        mockAuthService.signInResult = .success(true)
//
//        // Call the checkEmailSignInStatus method
//        viewModel.checkEmailSignInStatus(email: email)
//
//        // Verify the sign-in status is updated
//        XCTAssertTrue(SharedDataRepository.instance.isSignedIn)
//    }
//
//    func testPostDraftOrderForShoppingCart() {
//        // Set up mock data
//        let urlString = "https://example.com/draft_orders"
//        let parameters = ["draft_order": ["line_items": [["variant_id": 44382096457889, "quantity": 1]]]]
//        let response = OneDraftOrderResponse(draftOrder: DraftOrder(id: "1234567890"))
//
//        // Call the postDraftOrderForShoppingCart method
//        viewModel.postDraftOrderForShoppingCart(urlString: urlString, parameters: parameters) { response in
//            // Verify the response is set
//            XCTAssertNotNil(response)
//            XCTAssertEqual(response?.draftOrder?.id, "1234567890")
//        }
//    }
//
//    func testFetchCustomerID() {
//        // Set up mock data
//        let email = "test@example.com"
//        let customerDataModel = CustomerData(customerId: "1234567890", name: "John Doe", email: email, favouriteId: "1234567890", shoppingCartId: "1234567890")
//        mockAuthService.signInResult = .success(customerDataModel)
//
//        // Call the fetchCustomerID method
//        viewModel.fetchCustomerID()
//
//        // Verify the customer data is set
//        XCTAssertNotNil(SharedDataRepository.instance.customerName)
//        XCTAssertEqual(SharedDataRepository.instance.customerName, "John Doe")
//        XCTAssertNotNil(SharedDataRepository.instance.customerId)
//        XCTAssertEqual(SharedDataRepository.instance.customerId, "1234567890")
//    }
//
//    func testDraftOrderDummyModel1() {
//        // Call the draftOrderDummyModel1 method
//        let draftOrder = viewModel.draftOrderDummyModel1()
//
//        // Verify the draft order is set
//        XCTAssertNotNil(draftOrder)
//        XCTAssertEqual(draftOrder?["draft_order"]?["line_items"]?[0]?["variant_id"] as? Int, 44382096457889)
//    }
//
//    func testDraftOrderDummyModel2() {
//        // Call the draftOrderDummyModel2 method
//        let draftOrder = viewModel.draftOrderDummyModel2()
//
//        // Verify the draft order is set
//        XCTAssertNotNil(draftOrder)
//        XCTAssertEqual(draftOrder?["draft_order"]?["line_items"]?[0]?["variant_id"] as? Int, 44382094393505)
//    }
//
//    func testAddValueToUserDefaults() {
//        // Set up mock data
//        let value = "test value"
//        let key = "test key"
//
//        // Call the addValueToUserDefaults method
//        viewModel.addValueToUserDefaults(value: value, forKey: key)
//
//        // Verify the value is set in UserDefaults
//        XCTAssertEqual(UserDefaults.standard.string(forKey: key), value)
//    }
//
//    func testSetDraftOrderId() {
//        // Set up mock data
//        let email = "test@example.com"
//        let shoppingCartID = "1234567890"
//
//        // Call the setDraftOrderId method
//        viewModel.setDraftOrderId(email: email, shoppingCartID: shoppingCartID)
//
//        // Verify the shopping cart ID is set in Firebase
//        XCTAssertEqual(mockAuthService.setShoppingCartIdEmail, email)
//        XCTAssertEqual(mockAuthService.setShoppingCartIdShoppingCartId, shoppingCartID)
//    }
//
//    func testGetDraftOrderID() {
//        // Set up mock data
//        let email = "test@example.com"
//        let shoppingCartId = "1234567890"
//        mockAuthService.signInResult = .success(shoppingCartId)
//
//        // Call the getDraftOrderID method
//        viewModel.getDraftOrderID(email: email)
//
//        // Verify the shopping cart ID is set in SharedDataRepository
//        XCTAssertEqual(SharedDataRepository.instance.draftOrderId, shoppingCartId)
//    }
//
//    func testGetUserDraftOrderId() {
//        // Set up mock data
//        let email = "test@example.com"
//        let shoppingCartId = "1234567890"
//        mockAuthService.signInResult = .success(shoppingCartId)
//
//        // Call the getUserDraftOrderId method
//        viewModel.getUserDraftOrderId()
//
//        // Verify the shopping cart ID is set in SharedDataRepository
//        XCTAssertEqual(SharedDataRepository.instance.draftOrderId, shoppingCartId)
//    }
//}
