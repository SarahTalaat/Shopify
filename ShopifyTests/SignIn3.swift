import XCTest
@testable import Shopify

class SignInViewModelTests: XCTestCase {

    var viewModel: SignInViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SignInViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Mock FirebaseAuthService for testing
    class MockFirebaseAuthService3: FirebaseAuthService {

        var signInResult: Result<UserModel, Error>?
        var updateSignInStatusResult: Result<Void, Error>?

        override func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
            if let signInResult = signInResult {
                completion(signInResult)
            } else {
                // Simulate default behavior or handle as needed
                completion(.failure(NSError(domain: "MockAuthService", code: 500, userInfo: nil)))
            }
        }

        override func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void) {
            if let updateSignInStatusResult = updateSignInStatusResult {
                switch updateSignInStatusResult {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            } else {
                // Simulate default behavior or handle as needed
                completion(false)
            }
        }

        // Add more overrides for other FirebaseAuthService methods used in SignInViewModel
    }

    // Mock NetworkServiceAuthentication for testing
    class MockNetworkServiceAuthentication3: NetworkServiceAuthentication {

        var requestFunctionResult: Result<OneDraftOrderResponse, Error>?

        func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<OneDraftOrderResponse, Error>) -> Void) {
            if let requestFunctionResult = requestFunctionResult {
                completion(requestFunctionResult)
            } else {
                // Simulate default behavior or handle as needed
                completion(.failure(NSError(domain: "MockNetworkService", code: 500, userInfo: nil)))
            }
        }

        // Add more overrides for other NetworkServiceAuthentication methods used in SignInViewModel
    }

    // Example test case for signIn method
    func testSignIn_Success() {
        // Arrange
        let expectation = self.expectation(description: "Sign in expectation")
        let mockAuthService = MockFirebaseAuthService3(forTesting: true)
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
            XCTAssertEqual(self.viewModel.user?.email, email)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }

    // Example test case for postDraftOrderForShoppingCart method
//    func testPostDraftOrderForShoppingCart_Success() {
//        // Arrange
//        let expectation = self.expectation(description: "Post draft order expectation")
//        let mockNetworkService = MockNetworkServiceAuthentication3()
//        viewModel.networkService = mockNetworkService // Inject mock service
//        let urlString = "mockURL"
//        let parameters: [String: Any] = [:]
//        mockNetworkService.requestFunctionResult = .success(OneDraftOrderResponse(draftOrder: DraftOrder(id: "123")))
//
//        // Act
//        viewModel.postDraftOrderForShoppingCart(urlString: urlString, parameters: parameters) { response in
//            // Assert
//            XCTAssertNotNil(response)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 2.0, handler: nil)
//    }

    // Add more test cases for other methods in SignInViewModel as needed
}
