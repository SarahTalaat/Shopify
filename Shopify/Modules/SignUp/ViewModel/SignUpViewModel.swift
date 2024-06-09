import Foundation

class SignUpViewModel: SignUpViewModelProtocol {
    private let authServiceProtocol: AuthServiceProtocol
    private let networkServiceAuthentication: NetworkServiceAuthenticationProtocol
    
    var user: UserModel? {
        didSet {
            print("User model updated: \(String(describing: user))")
            self.bindUserViewModelToController()
        }
    }
    
    var errorMessage: String? {
        didSet {
            print("Error message updated: \(String(describing: errorMessage))")
            self.bindErrorViewModelToController()
        }
    }
    
    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
    init(authServiceProtocol: AuthServiceProtocol, networkServiceAuthentication: NetworkServiceAuthenticationProtocol) {
        self.authServiceProtocol = authServiceProtocol
        self.networkServiceAuthentication = networkServiceAuthentication
    }
    
    func signUp(email: String, password: String, firstName: String)  {
        print("Sign up called with email: \(email), firstName: \(firstName)")
        
        let customerRequest = CustomerRequest(first_name: firstName, email: email, verified_email: true)
        let customerModelRequest = CustomerModelRequest(customer: customerRequest)
        
        authServiceProtocol.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                
                print("Sign up successful with user: \(user)")
                
                
                self?.user = user
                
                
                print("Posting customer data with email: \(customerModelRequest.customer.email), name: \(customerModelRequest.customer.first_name ) , verified email : \(customerModelRequest.customer.verified_email)")
                
                
                let parameters: [String: Any] = [
                    "customer": [
                       "first_name": customerModelRequest.customer.first_name,
                        "email": customerModelRequest.customer.email,
                        "verified_email": customerModelRequest.customer.verified_email,
                    ]
                ]
                
                self?.postCustomerData(customerModelRequest: parameters)
                
                
            case .failure(let error):
                print("Sign up failed with error: \(error)")
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func postCustomerData(customerModelRequest: [String:Any]) {
        print("postCustomerData called with customerModelRequest: \(customerModelRequest)")
        
        networkServiceAuthentication.postCustomerData(customer: customerModelRequest) { [weak self] result in
            print("postCustomerData result: \(result)")
            switch result {
            case .success(let value):
                print("postCustomerData success: \(value.customers?[0].first_name ?? "default firstName")")
                
            case .failure(let error):
                print("postCustomerData failure: \(error)")
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
