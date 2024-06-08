


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
                self?.postCustomerData(customerRequest: customerModelRequest)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func postCustomerData(customerRequest: CustomerModelRequest) {
        guard let customer = customerRequest.customer else {
            // Handle the case when customer is nil
            return
        }
        networkServiceAuthentication.postCustomerData(customer: customer) { [weak self] result in
            switch result {
            case .success(let value):
                print("vm success : \(value.customer?.email)")
                // Handle the customer object as needed
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }

}
