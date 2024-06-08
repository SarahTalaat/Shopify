


import Foundation


class SignUpViewModel: SignUpViewModelProtocol {
    private let authServiceProtocol: AuthServiceProtocol
    private let networkServiceAuthentication: NetworkServiceAuthenticationProtocol
    
    var user: UserModel? {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.bindErrorViewModelToController()
        }
    }
    
    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
    init(authServiceProtocol: AuthServiceProtocol, networkServiceAuthentication: NetworkServiceAuthenticationProtocol) {
        self.authServiceProtocol = authServiceProtocol
        self.networkServiceAuthentication = networkServiceAuthentication
    }
    
    func signUp(firstName: String, email: String, verifiedEmail: Bool) {
        let customerRequest = CustomerRequest(first_name: firstName, email: email, verified_email: true)
        let customerModelRequest = CustomerModelRequest(customer: customerRequest)


        authServiceProtocol.signUp(email: email, password: "yourPassword") { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.postCustomerData(customerModelRequest: customerModelRequest)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func postCustomerData(customerModelRequest: CustomerModelRequest) {

        networkServiceAuthentication.postCustomerData(customer: customerModelRequest, completion: { [weak self] result in
            switch result {
            case .success(let value):
                print("vm success : \(value.customers)")
                // Handle the customer object as needed
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        })
    }

}
