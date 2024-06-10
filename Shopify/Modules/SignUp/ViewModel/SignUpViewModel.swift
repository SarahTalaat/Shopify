


import Foundation

class SignUpViewModel: SignUpViewModelProtocol {
    private let authServiceProtocol: AuthServiceProtocol
    private let networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol
    
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
    
    init(authServiceProtocol: AuthServiceProtocol, networkServiceAuthenticationProtocol: NetworkServiceAuthenticationProtocol) {
        self.authServiceProtocol = authServiceProtocol
        self.networkServiceAuthenticationProtocol = networkServiceAuthenticationProtocol
    }
    
    func signUp(email: String, password: String, firstName: String)  {
        print("vm Sign up called with email: \(email), firstName: \(firstName)")
        
        let customerRequest = CustomerRequest(first_name: firstName, email: email, verified_email: true)
        let customerModelRequest = CustomerModelRequest(customer: customerRequest)
        
        authServiceProtocol.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                print("vm Sign up successful with user: \(user)")
                self?.user = user
                
                let parameters: [String: Any] = [
                    "customer": [
                        "verified_email": customerModelRequest.customer.verified_email,
                        "email": customerModelRequest.customer.email,
                        "first_name": customerModelRequest.customer.first_name
                    ]
                ]
                
                let urlString = APIConfig.customers.url
                self?.postNewCustomer(urlString: urlString, parameters: parameters, name: firstName, email: email)
            case .failure(let error):
                print("vm Sign up failed with error: \(error)")
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func postNewCustomer(urlString: String, parameters: [String:Any], name: String , email: String){
    
        self.networkServiceAuthenticationProtocol.requestFunction(urlString: urlString, method: .post, model: parameters, completion: { [weak self] (result: Result<CustomerResponse, Error>) in
            switch result {
            case .success(let response):
                print("vm Customer data posted successfully: \(response)")
                self?.authServiceProtocol.saveCustomerId(name: name, email: email, id: "\(response.customer.id)")
            case .failure(let error):
                print("vm Failed to post customer data: \(error.localizedDescription)")
            }
        })
        
        
    }
    

    
}



/*
 7501423804577 7501423804577
 */
