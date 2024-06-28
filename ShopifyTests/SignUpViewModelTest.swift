import XCTest
@testable import Shopify

class SignUpViewModelTests: XCTestCase {

    var viewModel: SignUpViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SignUpViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    class MockFirebaseAuthService4: FirebaseAuthService {

        var signUpResult: Result<UserModel, Error>?
        var isEmailTakenResult: Bool?

        override func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
            if let signUpResult = signUpResult {
                completion(signUpResult)
            } else {
                completion(.failure(NSError(domain: "MockFirebaseAuthService", code: 500, userInfo: nil)))
            }
        }

        override func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
            if let isEmailTakenResult = isEmailTakenResult {
                completion(isEmailTakenResult)
            } else {
                completion(false)
            }
        }
    }

    class MockNetworkServiceAuthentication4: NetworkServiceAuthentication {

        var requestFunctionResult: Result<CustomerResponse, Error>?

        func requestFunction(urlString: String, method: HTTPMethod, model: [String: Any], completion: @escaping (Result<CustomerResponse, Error>) -> Void) {
            if let requestFunctionResult = requestFunctionResult {
                completion(requestFunctionResult)
            } else {
                completion(.failure(NSError(domain: "MockNetworkServiceAuthentication", code: 500, userInfo: nil)))
            }
        }
    }

    func testSignUp_Success() {
        // Arrange
        let expectation = self.expectation(description: "Sign up expectation")
        let mockAuthService = MockFirebaseAuthService4(forTesting: true)
        viewModel.authService = mockAuthService // Inject mock service
        let email = "shopifyapp.test201@gmail.com"
        let password = "@A123456"
        mockAuthService.signUpResult = .success(UserModel(uid: "id", email: email)) // Set mock result

        // Act
        viewModel.signUp(email: email, password: password, firstName: "Sarah")

        // Assert
        DispatchQueue.main.asyncAfter(deadline:.now() + 30.0) {
            // Perform assertions based on expected behavior
            XCTAssertNotNil(self.viewModel.user)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }

    func testSignUp_Failure() {
        // Arrange
        let expectation = self.expectation(description: "Sign up expectation")
        let mockAuthService = MockFirebaseAuthService4(forTesting: true)
        viewModel.authService = mockAuthService // Inject mock service
        let email = "test@example.com"
        let password = "password123"
        mockAuthService.signUpResult = .failure(NSError(domain: "MockFirebaseAuthService", code: 500, userInfo: nil)) // Set mock result
 
        // Act
        viewModel.signUp(email: email, password: password, firstName: "John")

        // Assert
        DispatchQueue.main.asyncAfter(deadline:.now() + 30.0) {
            // Perform assertions based on expected behavior
            XCTAssertNil(self.viewModel.user)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }

    func testSignUp_EmailTaken() {
        // Arrange
        let expectation = self.expectation(description: "Sign up expectation")
        let mockAuthService = MockFirebaseAuthService4(forTesting: true)
        viewModel.authService = mockAuthService // Inject mock service
        let email = "shopifyapp.test7@example.com"
        let password = "@A1234567"
        mockAuthService.isEmailTakenResult = true // Set mock result

        // Act
        viewModel.signUp(email: email, password: password, firstName: "Sarah")

        // Assert
        DispatchQueue.main.asyncAfter(deadline:.now() + 30.0) {
            // Perform assertions based on expected behavior
          //  XCTAssertNil(self.viewModel.user)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0, handler: nil)
    }
       
    }


