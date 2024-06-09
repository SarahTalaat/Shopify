


import Foundation

class SignUpViewModel: SignUpViewModelProtocol {
    private let authServiceProtocol: AuthServiceProtocol
    private let networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol
    
    var user: UserModel? {
        didSet {
            print("vm User model updated: \(String(describing: user))")
            print("")
            self.bindUserViewModelToController()
        }
    }
    
    var errorMessage: String? {
        didSet {
            print("vm Error message updated: \(String(describing: errorMessage))")
            print("")
            self.bindErrorViewModelToController()
        }
    }
    
    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
    init(authServiceProtocol: AuthServiceProtocol, networkServiceAuthentication: NetworkServiceAuthenticationProtocol) {
        self.authServiceProtocol = authServiceProtocol
        self.networkServiceAuthenticationProtocol = networkServiceAuthentication
    }
    
    func signUp(email: String, password: String, firstName: String)  {
        print("vm Sign up called with email: \(email), firstName: \(firstName)")
        print("")
        
        let customerRequest = CustomerRequest(first_name: firstName, email: email, verified_email: true)
        let customerModelRequest = CustomerModelRequest(customer: customerRequest)
        
        authServiceProtocol.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                
                print("vm Sign up successful with user: \(user)")
                print("")
                
                
                self?.user = user
                
                
                print("vm Posting customer data with email: \(customerModelRequest.customer.email), name: \(customerModelRequest.customer.first_name ) , verified email : \(customerModelRequest.customer.verified_email)")
                print("")
                
                let parameters: [String: Any] = [
                    "customer": [
                        "verified_email": customerModelRequest.customer.verified_email,
                        "email": customerModelRequest.customer.email,
                        "first_name": customerModelRequest.customer.first_name
                        
                    ]
                ]
                let endPoint = APIConfig.customers.resource
                self?.postCustomerData(endpoint: endPoint, customerModelRequest: parameters)
                
                
            case .failure(let error):
                print("vm Sign up failed with error: \(error)")
                print("")
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    

    func postCustomerData(endpoint: String, customerModelRequest: [String:Any]) {
        print("vm postCustomerData called with endpoint: \(endpoint), customerModelRequest: \(customerModelRequest)")
        print("")
        
        let apiKey = Constants.apiKey
        let password = Constants.adminApiAccessToken
        let hostName = APIConfig.hostName
        let version = Constants.version
        
        // Construct the full URL using the provided endpoint
        let urlString = "https://\(apiKey):\(password)@\(hostName)/admin/api/\(version)/\(endpoint).json"
        
        networkServiceAuthenticationProtocol.postCustomerData(urlString: urlString, customer: customerModelRequest) { (result: Result<CustomersModelResponse, Error>) in
            
            print("vm result: \(result)")
            print("")
            switch result {
            case .success(let response):
                print("vm Customer data posted successfully: \(response)")
                print("")
            case .failure(let error):
                print("vm Failed to post customer data: \(error.localizedDescription)")
                print("")
                
                // Additional error handling for decoding failure
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    // Handle decoding error appropriately, e.g., log, show error message to user, etc.
                }
            }
        }
    }
}
