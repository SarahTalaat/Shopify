import Foundation
import Reachability

class SignUpViewModel {

    var user: UserModel? {
        didSet {
            print("vm User model updated: \(String(describing: user))")
            bindUserViewModelToController()
        }
    }
    
    var errorMessage: String? {
        didSet {
            print("vm Error message updated: \(String(describing: errorMessage))")
            bindErrorViewModelToController()
        }
    }
    
    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
    
    var authService: FirebaseAuthService!
    var networkService: NetworkServiceAuthentication!

    init(authService: FirebaseAuthService = FirebaseAuthService.instance , networkService:NetworkServiceAuthentication = NetworkServiceAuthentication.instance) {
        self.authService = authService
        self.networkService = networkService
    }
    
    var reachability: Reachability?
    var networkStatusChanged: ((Bool) -> Void)?
    
    func setupReachability() {
        reachability = try? Reachability()
        reachability?.whenReachable = { reachability in
            self.networkStatusChanged?(reachability.connection == .wifi)
            print("wifi connection")
        }
        reachability?.whenUnreachable = { _ in
            self.networkStatusChanged?(false)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    func signUp(email: String, password: String, firstName: String) {
        print("vm Sign up called with email: \(email), firstName: \(firstName)")

        
        let customerRequest = CustomerRequest(first_name: firstName, email: email, verified_email: true)
        let customerModelRequest = CustomerModelRequest(customer: customerRequest)

        guard isEmailFormatValid(email) else {
            errorMessage = "Invalid email format. Please enter a valid email address."
            return
        }

        FirebaseAuthService.instance.isEmailTaken(email: email) { [weak self] isTaken in
            guard !isTaken else {
                self?.errorMessage = "This email is already in use. Please choose a different email address."
                return
            }

            let passwordErrors = self?.validatePassword(password) ?? []
            guard passwordErrors.isEmpty else {
                let errorMessage = passwordErrors.joined(separator: "\n")
                self?.errorMessage = errorMessage
                return
            }

           FirebaseAuthService.instance.signUp(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let user):
                    print("vm Sign up successful with user: \(user)")
                    self?.user = user

                    let createCustomer: [String: Any] = [
                        "customer": [
                            "verified_email": customerModelRequest.customer.verified_email,
                            "email": customerModelRequest.customer.email,
                            "first_name": customerModelRequest.customer.first_name
                        ]
                    ]
                    
                   

                    let urlString = APIConfig.customers.url
                    self?.postNewCustomer(urlString: urlString, parameters: createCustomer, name: firstName, email: email)
                
                case .failure(let error):
                    print("vm Sign up failed with error: \(error)")
                    self?.handleSignUpError(error)
                }
            }
        }
    }

    func validatePassword(_ password: String) -> [String] {
        var errors: [String] = []

        if !isPasswordLengthValid(password) {
            errors.append("Password must be at least 6 characters long.")
        }

        if !containsUppercaseLetter(password) {
            errors.append("Password must contain at least one capital letter.")
        }

        if !containsSpecialCharacter(password) {
            errors.append("Password must contain at least one special character.")
        }

        if !containsNumber(password) {
            errors.append("Password must contain at least one number.")
        }

        return errors
    }

    func isPasswordLengthValid(_ password: String) -> Bool {
        return password.count >= 6
    }

    func containsUppercaseLetter(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: .uppercaseLetters) != nil
    }

    func containsSpecialCharacter(_ password: String) -> Bool {
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?")
        return password.rangeOfCharacter(from: specialCharacterSet) != nil
    }

    func containsNumber(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: .decimalDigits) != nil
    }

    func postNewCustomer(urlString: String, parameters: [String:Any], name: String , email: String) {
        NetworkServiceAuthentication.instance.requestFunction(urlString: urlString, method: .post, model: parameters, completion: { [weak self] (result: Result<CustomerResponse, Error>) in
            switch result {
            case .success(let response):
                print("vm Customer data posted successfully: \(response)")

                FirebaseAuthService.instance.saveCustomerId(name: name, email: email, id: "\(response.customer.id)", favouriteId: "", shoppingCartId: "", productId: "-1", productTitle: "", productVendor: "" , productImage: "", isSignedIn: "\(false)")
            case .failure(let error):
                print("vm Failed to post customer data: \(error.localizedDescription)")
            }
        })
    }
    


     func isEmailFormatValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

     func handleSignUpError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    


}
