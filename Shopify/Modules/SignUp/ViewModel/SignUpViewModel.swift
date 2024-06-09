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
                
                self?.postCustomerData(customerModelRequest: parameters)
                
                
            case .failure(let error):
                print("vm Sign up failed with error: \(error)")
                print("")
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func postCustomerData(customerModelRequest: [String:Any]) {
        print("vm postCustomerData called with customerModelRequest: \(customerModelRequest)")
        print("")
        
        let apiConfig = APIConfig.customers
        
        print("vm api config: \(apiConfig)")
        print("")
        print("vm api config url: \(apiConfig.url)")
        print("")
        
        networkServiceAuthenticationProtocol.postCustomerData(apiConfig: apiConfig, customer: customerModelRequest, completion: { (result: Result<CustomersModelResponse, Error>) in
            
            print("vm result: \(result)")
            print("")
            switch result {
            case .success(let response):
                print("vm Customer data posted successfully: \(response)")
                print("")
            case .failure(let error):
                print("vm Failed to post customer data: \(error.localizedDescription)")
                print("")
            }
        })
    }
}

/*
 let apiConfig = APIConfig.customers

 postCustomerData(apiConfig: apiConfig, customer: customerData) { (result: Result<CustomersModelResponse, Error>) in
     switch result {
     case .success(let response):
         print("Customer data posted successfully: \(response)")
     case .failure(let error):
         print("Failed to post customer data: \(error.localizedDescription)")
     }
 }

 */
