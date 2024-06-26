import XCTest
@testable import Shopify

class SignInViewModelTests: XCTestCase {

   

    override func setUp() {
        super.setUp()
     
    }

    override func tearDown() {
       
        super.tearDown()
    }

    class MockNetworkServiceAuthentication3: NetworkServiceAuthentication {

        var requestFunctionResult: Result<OneDraftOrderResponse, Error>?

        func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<OneDraftOrderResponse, Error>) -> Void) {
            if let requestFunctionResult = requestFunctionResult {
                completion(requestFunctionResult)
            } else {
                completion(.failure(NSError(domain: "MockNetworkService", code: 500, userInfo: nil)))
            }
        }

    }

    // Example test case for signIn method
    func testSignIn_Success() {
        // Arrange
        let expectation = self.expectation(description: "Sign in expectation")
        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
        var  viewModel = SignInViewModel()
        viewModel.authService = mockAuthService // Inject mock service
        let email = "shopifyapp.test7@gmail.com"
        let id = "JfFRqCqJbaSSgNn9Nnm8xumPM1l1"
        let password = "@A123456"
        mockAuthService.signInResult = .success(UserModel(uid: id, email: email)) // Set mock result

        // Act
        viewModel.signIn(email: email, password: password)

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
            // Perform assertions based on expected behavior
            XCTAssertEqual(viewModel.user?.email, email)
            XCTAssertNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }

    func testSignIn_Failure() {
        // Arrange
        let expectation = self.expectation(description: "Sign in expectation")
        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
        var  viewModel = SignInViewModel()
        viewModel.authService = mockAuthService // Inject mock service
        let email = "shopifyapp.test7@gmail.com"
        let password = "@A1234567"
        mockAuthService.signInResult = .failure(NSError(domain: "MockAuthService", code: 500, userInfo: nil)) // Set mock result

        // Act
        viewModel.signIn(email: email, password: password)

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
            // Perform assertions based on expected behavior
            XCTAssertNil(viewModel.user)
            XCTAssertNotNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testFetchCustomerID() {
        let expectation = self.expectation(description: "Fetch customer ID expectation")
        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
        var  viewModel = SignInViewModel()
        viewModel.authService = mockAuthService
        let email = "shopifyapp.test7@gmail.com"
        let customerData = CustomerData(customerId: "7533489127585", name: "Sarah", email: email, favouriteId: "", shoppingCartId: "1036337250465")
        mockAuthService.fetchCustomerDataResult = customerData
        viewModel.user = UserModel(uid: "JfFRqCqJbaSSgNn9Nnm8xumPM1l1", email: email)

        viewModel.fetchCustomerID()

        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
            XCTAssertEqual(SharedDataRepository.instance.customerName, customerData.name)
            XCTAssertEqual(SharedDataRepository.instance.customerId, customerData.customerId)
            XCTAssertEqual(SharedDataRepository.instance.shoppingCartId, customerData.shoppingCartId)
            XCTAssertEqual(SharedDataRepository.instance.favouriteId, customerData.favouriteId)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    
    func testPostDraftOrderForShoppingCart() {
            let expectation = self.expectation(description: "Post draft order for shopping cart expectation")
            let mockNetworkService = MockNetworkServiceAuthentication3(forTesting: true)
            var  viewModel = SignInViewModel()
            viewModel.networkService = mockNetworkService
            let urlString = APIConfig.draft_orders.url
            let parameters = viewModel.draftOrderDummyModel1()
                let response = OneDraftOrderResponse(draftOrder: OneDraftOrderResponseDetails(
                    id: 1037010698401,
                    note: nil,
                    email: nil,
                    taxesIncluded: nil,
                    currency: nil,
                    invoiceSentAt: nil,
                    createdAt: nil,
                    updatedAt: nil,
                    taxExempt: nil,
                    completedAt: nil,
                    name: nil,
                    status: nil,
                    lineItems: [],
                    shippingAddress: nil,
                    billingAddress: nil,
                    invoiceUrl: nil,
                    appliedDiscount: nil,
                    orderId: nil,
                    shippingLine: nil,
                    taxLines: nil,
                    tags: nil,
                    noteAttributes: nil,
                    totalPrice: "",
                    subtotalPrice: "",
                    totalTax: nil,
                    paymentTerms: nil,
                    adminGraphqlApiId: nil
                ))
            mockNetworkService.requestFunctionResult = .success(response)

            viewModel.postDraftOrderForShoppingCart(urlString: urlString, parameters: parameters, name: "Sarah", email: "shopifyapp.test7@gmail.com") { draftOrderResponse in
                XCTAssertNotNil(draftOrderResponse?.draftOrder?.id)
                expectation.fulfill()
            }

            waitForExpectations(timeout: 30.0, handler: nil)
        }

    func testAddValueToUserDefaults() {
            let key = "TestKey"
            let value = "TestValue"
            var  viewModel = SignInViewModel()
            viewModel.addValueToUserDefaults(value: value, forKey: key)

            XCTAssertEqual(UserDefaults.standard.string(forKey: key), value)
        }





    func testGetDraftOrderID() {
          let expectation = self.expectation(description: "Get draft order ID expectation")
          let mockAuthService = MockFirebaseAuthService3(forTesting: true)
          var  viewModel = SignInViewModel()
          viewModel.authService = mockAuthService
          let email = "shopifyapp.test7@gmail.com"
          let shoppingCartID = "1036337250465"
          mockAuthService.getShoppingCartIdResult = shoppingCartID

          viewModel.getDraftOrderID(email: email)

          DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
              XCTAssertEqual(SharedDataRepository.instance.draftOrderId, shoppingCartID)
              XCTAssertEqual(UserDefaults.standard.string(forKey: Constants.userDraftId), shoppingCartID)
              expectation.fulfill()
          }

          waitForExpectations(timeout: 30.0, handler: nil)
      }
    
    func testGetUserDraftOrderId() {
        let expectation = self.expectation(description: "Get user draft order ID expectation")
        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
        var viewModel = SignInViewModel()
        viewModel.authService = mockAuthService
        let email = "shopifyapp.test7@gmail.com"
        SharedDataRepository.instance.customerEmail = email

        viewModel.getUserDraftOrderId()

        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
            XCTAssertNotNil(UserDefaults.standard.string(forKey: Constants.userDraftId))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }
}



//
//    func testUpdateSignInStatus() {
//        // Arrange
//        let expectation = self.expectation(description: "Update sign-in status expectation")
//        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        viewModel.authService = mockAuthService // Inject mock service
//        let email = "shopifyapp.test7@gmail.com"
//        mockAuthService.updateSignInStatusResult = .success(()) // Set mock result
//
//        // Act
//        viewModel.updateSignInStatus(email: email)
//
//        // Assert
//        DispatchQueue.main.async {
//            // Perform assertions based on expected behavior
//            XCTAssertEqual(self.viewModel.authService.updateSignInStatusResult, .success(()))
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testCheckEmailSignInStatus() {
//        // Arrange
//        let expectation = self.expectation(description: "Check email sign-in status expectation")
//        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        viewModel.authService = mockAuthService // Inject mock service
//        let email = "shopifyapp.test7@gmail.com"
//        mockAuthService.checkEmailSignInStatusResult = true // Set mock result
//
//        // Act
//        viewModel.checkEmailSignInStatus(email: email)
//
//        // Assert
//        DispatchQueue.main.async {
//            XCTAssertEqual(self.viewModel.authService.checkEmailSignInStatusResult, true)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testFetchCustomerID() {
//        // Arrange
//        let expectation = self.expectation(description: "Fetch customer ID expectation")
//        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        viewModel.authService = mockAuthService // Inject mock service
//        let email = "shopifyapp.test7@gmail.com"
//        let customerData = CustomerData(customerId: "123", name: "Test User", email: email, favouriteId: "fav123", shoppingCartId: "cart123")
//        mockAuthService.fetchCustomerDataResult = customerData // Set mock result
//        viewModel.user = UserModel(uid: "JfFRqCqJbaSSgNn9Nnm8xumPM1l1", email: email)
//
//        // Act
//        viewModel.fetchCustomerID()
//
//        // Assert
//        DispatchQueue.main.async {
//            XCTAssertEqual(SharedDataRepository.instance.customerName, customerData.name)
//            XCTAssertEqual(SharedDataRepository.instance.customerId, customerData.customerId)
//            XCTAssertEqual(SharedDataRepository.instance.shoppingCartId, customerData.shoppingCartId)
//            XCTAssertEqual(SharedDataRepository.instance.favouriteId, customerData.favouriteId)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testPostDraftOrderForShoppingCart() {
//        // Arrange
//        let expectation = self.expectation(description: "Post draft order for shopping cart expectation")
//        let mockNetworkService = MockNetworkServiceAuthentication3(forTesting: true)
//        viewModel.networkService = mockNetworkService // Inject mock service
//        let urlString = "https://example.com/draft_order"
//        let parameters = viewModel.draftOrderDummyModel1()
//        let response = OneDraftOrderResponse(draftOrder: DraftOrder(id: 123456789))
//        mockNetworkService.requestFunctionResult = .success(response) // Set mock result
//
//        // Act
//        viewModel.postDraftOrderForShoppingCart(urlString: urlString, parameters: parameters, name: "Test User", email: "test@example.com") { draftOrderResponse in
//            // Assert
//            XCTAssertEqual(draftOrderResponse?.draftOrder?.id, response.draftOrder?.id)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testAddValueToUserDefaults() {
//        // Arrange
//        let key = "TestKey"
//        let value = "TestValue"
//
//        // Act
//        viewModel.addValueToUserDefaults(value: value, forKey: key)
//
//        // Assert
//        XCTAssertEqual(UserDefaults.standard.string(forKey: key), value)
//    }
//
//    func testSetDraftOrderId() {
//        // Arrange
//        let expectation = self.expectation(description: "Set draft order ID expectation")
//        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        viewModel.authService = mockAuthService // Inject mock service
//        let email = "shopifyapp.test7@gmail.com"
//        let shoppingCartID = "cart123"
//
//        // Act
//        viewModel.setDraftOrderId(email: email, shoppingCartID: shoppingCartID)
//
//        // Assert
//        DispatchQueue.main.async {
//            // Perform assertions based on expected behavior
//            // Assuming that `setDraftOrderId` sets the draft order ID in some shared repository or property
//            XCTAssertEqual(SharedDataRepository.instance.shoppingCartId, shoppingCartID)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testGetDraftOrderID() {
//        // Arrange
//        let expectation = self.expectation(description: "Get draft order ID expectation")
//        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        viewModel.authService = mockAuthService // Inject mock service
//        let email = "shopifyapp.test7@gmail.com"
//        let shoppingCartID = "cart123"
//        mockAuthService.getShoppingCartId(email: email) { id, error in
//            XCTAssertEqual(id, shoppingCartID)
//            expectation.fulfill()
//        }
//
//        // Act
//        viewModel.getDraftOrderID(email: email)
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testGetUserDraftOrderId() {
//        // Arrange
//        let expectation = self.expectation(description: "Get user draft order ID expectation")
//        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
//        viewModel.authService = mockAuthService // Inject mock service
//        let email = "shopifyapp.test7@gmail.com"
//        SharedDataRepository.instance.customerEmail = email
//
//        // Act
//        viewModel.getUserDraftOrderId()
//
//        // Assert
//        DispatchQueue.main.async {
//            // Perform assertions based on expected behavior
//            XCTAssertEqual(self.viewModel.authService.getShoppingCartIdResult, "cart123")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }

