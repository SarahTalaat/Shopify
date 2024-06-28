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
       
    

    func testValidatePassword_InvalidPassword() {
        // Arrange
        let password = "short"
        let viewModel = SignUpViewModel()

        // Act
        let errors = viewModel.validatePassword(password)

        // Assert
        XCTAssertNotNil(errors)
        XCTAssertEqual(errors.count, 4)
        XCTAssertTrue(errors.contains("Password must be at least 6 characters long."))
        XCTAssertTrue(errors.contains("Password must contain at least one capital letter."))
        XCTAssertTrue(errors.contains("Password must contain at least one special character."))
        XCTAssertTrue(errors.contains("Password must contain at least one number."))
    }

    func testValidatePassword_ValidPassword() {
        // Arrange
        let password = "@A123456!"
        let viewModel = SignUpViewModel()

        // Act
        let errors = viewModel.validatePassword(password)

        // Assert
        XCTAssertEqual(errors.count, 0)
    }

    func testIsPasswordLengthValid_InvalidPassword() {
        // Arrange
        let password = "short"
        let viewModel = SignUpViewModel()

        // Act
        let isValid = viewModel.isPasswordLengthValid(password)

        // Assert
        XCTAssertFalse(isValid)
    }

    func testIsPasswordLengthValid_ValidPassword() {
        // Arrange
        let password = "Password123!"
        let viewModel = SignUpViewModel()

        // Act
        let isValid = viewModel.isPasswordLengthValid(password)

        // Assert
        XCTAssertTrue(isValid)
    }

    func testContainsUppercaseLetter_InvalidPassword() {
        // Arrange
        let password = "alllowercase"
        let viewModel = SignUpViewModel()

        // Act
        let containsUppercase = viewModel.containsUppercaseLetter(password)

        // Assert
        XCTAssertFalse(containsUppercase)
    }

    func testContainsUppercaseLetter_ValidPassword() {
        // Arrange
        let password = "Password123!"
        let viewModel = SignUpViewModel()

        // Act
        let containsUppercase = viewModel.containsUppercaseLetter(password)

        // Assert
        XCTAssertTrue(containsUppercase)
    }

    func testContainsSpecialCharacter_InvalidPassword() {
        // Arrange
        let password = "NoSpecialChars"
        let viewModel = SignUpViewModel()

        // Act
        let containsSpecialChar = viewModel.containsSpecialCharacter(password)

        // Assert
        XCTAssertFalse(containsSpecialChar)
    }

    func testContainsSpecialCharacter_ValidPassword() {
        // Arrange
        let password = "Password123!"
        let viewModel = SignUpViewModel()

        // Act
        let containsSpecialChar = viewModel.containsSpecialCharacter(password)

        // Assert
        XCTAssertTrue(containsSpecialChar)
    }

    func testContainsNumber_InvalidPassword() {
        // Arrange
        let password = "NoNumber"
        let viewModel = SignUpViewModel()

        // Act
        let containsNumber = viewModel.containsNumber(password)

        // Assert
        XCTAssertFalse(containsNumber)
    }

    func testContainsNumber_ValidPassword() {
        // Arrange
        let password = "Password123!"
        let viewModel = SignUpViewModel()

        // Act
        let containsNumber = viewModel.containsNumber(password)

        // Assert
        XCTAssertTrue(containsNumber)
    }

//    func testPostNewCustomer_Success() {
//        // Arrange
//        let expectation = self.expectation(description: "Post new customer expectation")
//        let mockNetworkService = MockNetworkServiceAuthentication4(forTesting: true)
//        viewModel.networkService = mockNetworkService // Inject mock service
//        let urlString = "https://example.com/customers"
//        let parameters: [String: Any] = ["customer": ["first_name": "John", "email": "john@example.com"]]
//        mockNetworkService.requestFunctionResult = .success(CustomerResponse(customer: Customer(id: 1, first_name: "John", email: "john@example.com")))
//
//        // Act
//        viewModel.postNewCustomer(urlString: urlString, parameters: parameters, name: "John", email: "john@example.com")
//
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
//            // Perform assertions based on expected behavior
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }
//
//    func testPostNewCustomer_Failure() {
//        // Arrange
//        let expectation = self.expectation(description: "Post new customer expectation")
//        let mockNetworkService = MockNetworkServiceAuthentication4(forTesting: true)
//        viewModel.networkService = mockNetworkService // Inject mock service
//        let urlString = "https://example.com/customers"
//        let parameters: [String: Any] = ["customer": ["first_name": "John", "email": "john@example.com"]]
//        mockNetworkService.requestFunctionResult = .failure(NSError(domain: "MockNetworkServiceAuthentication", code: 500, userInfo: nil))
//
//        // Act
//        viewModel.postNewCustomer(urlString: urlString, parameters: parameters, name: "John", email: "john@example.com")
//
//        // Assert
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
//            // Perform assertions based on expected behavior
//            XCTAssertNil(FirebaseAuthService.instance.customerId)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30.0, handler: nil)
//    }

    func testIsEmailFormatValid_InvalidEmail() {
        // Arrange
        let email = "invalidemail"
        let viewModel = SignUpViewModel()

        // Act
        let isValid = viewModel.isEmailFormatValid(email)

        // Assert
        XCTAssertFalse(isValid)
    }

    func testIsEmailFormatValid_ValidEmail() {
        // Arrange
        let email = "validemail@example.com"
        let viewModel = SignUpViewModel()

        // Act
        let isValid = viewModel.isEmailFormatValid(email)

        // Assert
        XCTAssertTrue(isValid)
    }

    func testHandleSignUpError_Error() {
        // Arrange
        let error = NSError(domain: "MockFirebaseAuthService", code: 500, userInfo: nil)
        let viewModel = SignUpViewModel()

        // Act
        viewModel.handleSignUpError(error)

        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, error.localizedDescription)
    }


} 
